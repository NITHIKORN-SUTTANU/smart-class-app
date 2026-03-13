import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:intl/intl.dart';
import '../db/database_helper.dart';
import '../services/firestore_service.dart';
import '../models/checkin_record.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _studentIdCtrl = TextEditingController();
  final _prevTopicCtrl = TextEditingController();
  final _expectedTopicCtrl = TextEditingController();

  String _qrResult = '';
  bool _qrScanned = false;
  double? _lat;
  double? _lng;
  bool _gpsLoading = false;
  int _mood = 3;
  bool _submitting = false;

  final List<String> _moodLabels = [
    '',
    '😡 Very Negative',
    '🙁 Negative',
    '😐 Neutral',
    '🙂 Positive',
    '😄 Very Positive',
  ];

  @override
  void dispose() {
    _studentIdCtrl.dispose();
    _prevTopicCtrl.dispose();
    _expectedTopicCtrl.dispose();
    super.dispose();
  }

  Future<void> _getGPS() async {
    setState(() => _gpsLoading = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission denied permanently.')),
          );
        }
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
      setState(() {
        _lat = pos.latitude;
        _lng = pos.longitude;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('GPS error: $e')));
      }
    } finally {
      setState(() => _gpsLoading = false);
    }
  }

  Future<void> _scanQR() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const _QRScannerPage()),
    );
    if (result != null) {
      setState(() {
        _qrResult = result;
        _qrScanned = true;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_qrScanned) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please scan the QR code first.')));
      return;
    }
    if (_lat == null || _lng == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please capture your GPS location first.')));
      return;
    }

    setState(() => _submitting = true);
    final record = CheckInRecord(
      studentId: _studentIdCtrl.text.trim(),
      checkInTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      gpsLat: _lat!,
      gpsLng: _lng!,
      qrCodeData: _qrResult,
      previousTopic: _prevTopicCtrl.text.trim(),
      expectedTopic: _expectedTopicCtrl.text.trim(),
      moodBefore: _mood,
    );

    await DatabaseHelper.instance.insertCheckIn(record);
    // Sync to Firestore (optional, will fail gracefully if Firebase not configured)
    await FirestoreService.instance.syncCheckIn(record);
    setState(() => _submitting = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Check-in saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        title: const Text('Check-in', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SectionCard(
                title: 'Student ID',
                child: TextFormField(
                  controller: _studentIdCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Enter your student ID',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'GPS Location',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_lat != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Lat: ${_lat!.toStringAsFixed(6)}, Lng: ${_lng!.toStringAsFixed(6)}',
                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ElevatedButton.icon(
                      onPressed: _gpsLoading ? null : _getGPS,
                      icon: _gpsLoading
                          ? const SizedBox(
                              width: 16, height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.my_location),
                      label: Text(_gpsLoading ? 'Getting location...' : 'Get GPS Location'),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1565C0)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'Scan QR Code',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_qrScanned)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Scanned: $_qrResult',
                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ElevatedButton.icon(
                      onPressed: _scanQR,
                      icon: const Icon(Icons.qr_code_scanner),
                      label: Text(_qrScanned ? 'Re-scan QR Code' : 'Scan QR Code'),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6A1B9A)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'Pre-class Reflection',
                child: Column(
                  children: [
                    TextFormField(
                      controller: _prevTopicCtrl,
                      decoration: const InputDecoration(
                        labelText: 'What was the previous class topic?',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _expectedTopicCtrl,
                      decoration: const InputDecoration(
                        labelText: 'What do you expect to learn today?',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Mood before class: ${_moodLabels[_mood]}',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    Slider(
                      value: _mood.toDouble(),
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: _moodLabels[_mood],
                      activeColor: const Color(0xFF1565C0),
                      onChanged: (v) => setState(() => _mood = v.round()),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [Text('😡'), Text('🙁'), Text('😐'), Text('🙂'), Text('😄')],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _submitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Submit Check-in',
                        style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── QR Scanner Page ──────────────────────────────────────────────────────────

class _QRScannerPage extends StatefulWidget {
  const _QRScannerPage();

  @override
  State<_QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<_QRScannerPage> {
  bool _detected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Scan QR Code', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: MobileScanner(
        onDetect: (capture) {
          if (_detected) return;
          final barcode = capture.barcodes.firstOrNull;
          if (barcode?.rawValue != null) {
            _detected = true;
            Navigator.pop(context, barcode!.rawValue);
          }
        },
      ),
    );
  }
}

// ── Reusable Section Card ────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF1A237E))),
            const Divider(),
            child,
          ],
        ),
      ),
    );
  }
}
