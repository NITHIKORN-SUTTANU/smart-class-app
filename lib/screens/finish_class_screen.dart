import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:intl/intl.dart';
import '../db/database_helper.dart';
import '../services/firestore_service.dart';
import '../models/checkin_record.dart';

class FinishClassScreen extends StatefulWidget {
  const FinishClassScreen({super.key});

  @override
  State<FinishClassScreen> createState() => _FinishClassScreenState();
}

class _FinishClassScreenState extends State<FinishClassScreen> {
  final _formKey = GlobalKey<FormState>();
  final _studentIdCtrl = TextEditingController();
  final _whatLearnedCtrl = TextEditingController();
  final _feedbackCtrl = TextEditingController();

  String _qrResult = '';
  bool _qrScanned = false;
  double? _lat;
  double? _lng;
  bool _gpsLoading = false;
  bool _submitting = false;

  @override
  void dispose() {
    _studentIdCtrl.dispose();
    _whatLearnedCtrl.dispose();
    _feedbackCtrl.dispose();
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
    final record = CheckOutRecord(
      studentId: _studentIdCtrl.text.trim(),
      checkOutTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      gpsLat: _lat!,
      gpsLng: _lng!,
      qrCodeData: _qrResult,
      whatLearned: _whatLearnedCtrl.text.trim(),
      feedback: _feedbackCtrl.text.trim(),
    );

    await DatabaseHelper.instance.insertCheckOut(record);
    // Sync to Firestore (optional, will fail gracefully if Firebase not configured)
    await FirestoreService.instance.syncCheckOut(record);
    setState(() => _submitting = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Finish class saved successfully!'),
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
        backgroundColor: const Color(0xFF2E7D32),
        title: const Text('Finish Class', style: TextStyle(color: Colors.white)),
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
                color: const Color(0xFF2E7D32),
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
                color: const Color(0xFF2E7D32),
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
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'Scan QR Code',
                color: const Color(0xFF2E7D32),
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
                title: 'Post-class Reflection',
                color: const Color(0xFF2E7D32),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _whatLearnedCtrl,
                      decoration: const InputDecoration(
                        labelText: 'What did you learn today?',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _feedbackCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Feedback for the class or instructor',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _submitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Submit Finish Class',
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
  final Color color;

  const _SectionCard({required this.title, required this.child, required this.color});

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
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: color)),
            const Divider(),
            child,
          ],
        ),
      ),
    );
  }
}
