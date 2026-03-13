import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:intl/intl.dart';
import '../constants/app_theme.dart';
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
          _showSnack('Location permission denied permanently.', isError: true);
        }
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
          locationSettings:
              const LocationSettings(accuracy: LocationAccuracy.high));
      setState(() {
        _lat = pos.latitude;
        _lng = pos.longitude;
      });
    } catch (e) {
      if (mounted) _showSnack('GPS error: $e', isError: true);
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
      _showSnack('Please scan the QR code first.', isError: true);
      return;
    }
    if (_lat == null || _lng == null) {
      _showSnack('Please capture your GPS location first.', isError: true);
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
    await FirestoreService.instance.syncCheckOut(record);
    setState(() => _submitting = false);

    if (mounted) {
      _showSnack('Class session completed!', isError: false);
      Navigator.pop(context);
    }
  }

  void _showSnack(String msg, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg,
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.white)),
      backgroundColor: isError ? AppColors.error : AppColors.success,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Step 1 – Student ID
                      _SectionCard(
                        stepNumber: '1',
                        icon: Icons.badge_rounded,
                        title: 'Student ID',
                        accentColor: AppColors.secondary,
                        child: TextFormField(
                          controller: _studentIdCtrl,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: 'Enter your student ID',
                            prefixIcon: const Icon(Icons.person_outline_rounded,
                                color: AppColors.secondary, size: 20),
                          ),
                          style: GoogleFonts.poppins(fontSize: 14),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Student ID is required'
                              : null,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Step 2 – GPS
                      _SectionCard(
                        stepNumber: '2',
                        icon: Icons.location_on_rounded,
                        title: 'GPS Location',
                        accentColor: AppColors.gpsTeal,
                        statusWidget: _lat != null
                            ? _StatusBadge(
                                label: 'Captured',
                                color: AppColors.success,
                                icon: Icons.check_circle_rounded)
                            : _StatusBadge(
                                label: 'Required',
                                color: AppColors.textHint,
                                icon: Icons.radio_button_unchecked_rounded),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (_lat != null) ...[
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.successLight,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.my_location_rounded,
                                        color: AppColors.success, size: 16),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        '${_lat!.toStringAsFixed(6)}, ${_lng!.toStringAsFixed(6)}',
                                        style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: AppColors.success,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _gpsLoading ? null : _getGPS,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.gpsTeal),
                                icon: _gpsLoading
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white))
                                    : const Icon(Icons.my_location_rounded,
                                        size: 18),
                                label: Text(_gpsLoading
                                    ? 'Getting location…'
                                    : _lat != null
                                        ? 'Re-capture Location'
                                        : 'Get GPS Location'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Step 3 – QR Code
                      _SectionCard(
                        stepNumber: '3',
                        icon: Icons.qr_code_scanner_rounded,
                        title: 'Scan QR Code',
                        accentColor: AppColors.qrPurple,
                        statusWidget: _qrScanned
                            ? _StatusBadge(
                                label: 'Scanned',
                                color: AppColors.success,
                                icon: Icons.check_circle_rounded)
                            : _StatusBadge(
                                label: 'Required',
                                color: AppColors.textHint,
                                icon: Icons.radio_button_unchecked_rounded),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (_qrScanned) ...[
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.successLight,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.qr_code_rounded,
                                        color: AppColors.success, size: 16),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _qrResult,
                                        style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: AppColors.success,
                                            fontWeight: FontWeight.w500),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _scanQR,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.qrPurple),
                                icon: const Icon(Icons.qr_code_scanner_rounded,
                                    size: 18),
                                label: Text(_qrScanned
                                    ? 'Re-scan QR Code'
                                    : 'Scan QR Code'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Step 4 – Post-class Reflection
                      _SectionCard(
                        stepNumber: '4',
                        icon: Icons.lightbulb_rounded,
                        title: 'Post-class Reflection',
                        accentColor: AppColors.secondary,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: _whatLearnedCtrl,
                              maxLines: 3,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'What did you learn today?',
                                alignLabelWithHint: true,
                              ),
                              style: GoogleFonts.poppins(fontSize: 14),
                              validator: (v) =>
                                  (v == null || v.trim().isEmpty)
                                      ? 'This field is required'
                                      : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _feedbackCtrl,
                              maxLines: 3,
                              textInputAction: TextInputAction.done,
                              decoration: const InputDecoration(
                                labelText:
                                    'Feedback for the class or instructor',
                                alignLabelWithHint: true,
                              ),
                              style: GoogleFonts.poppins(fontSize: 14),
                              validator: (v) =>
                                  (v == null || v.trim().isEmpty)
                                      ? 'This field is required'
                                      : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Submit button
                      SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _submitting ? null : _submit,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondary),
                          child: _submitting
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white))
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.check_rounded,
                                        size: 20),
                                    const SizedBox(width: 8),
                                    Text('Submit & Finish Class',
                                        style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF047857),
            AppColors.secondary,
            Color(0xFF10B981),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 16, 24),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Finish Class',
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700)),
                    Text('Complete your learning session',
                        style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(38),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('4 steps',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Section Card ─────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String stepNumber;
  final IconData icon;
  final String title;
  final Color accentColor;
  final Widget child;
  final Widget statusWidget;

  const _SectionCard({
    required this.stepNumber,
    required this.icon,
    required this.title,
    required this.accentColor,
    required this.child,
    this.statusWidget = const SizedBox.shrink(),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: accentColor.withAlpha(15),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              border: Border(
                left: BorderSide(color: accentColor, width: 4),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(stepNumber,
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 10),
                Icon(icon, color: accentColor, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(title,
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                ),
                statusWidget,
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }
}

// ── Status Badge ─────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _StatusBadge(
      {required this.label, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 4),
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 11, color: color, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

// ── QR Scanner Page ───────────────────────────────────────────────────────────

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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Scan QR Code',
            style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              if (_detected) return;
              final barcode = capture.barcodes.firstOrNull;
              if (barcode?.rawValue != null) {
                _detected = true;
                Navigator.pop(context, barcode!.rawValue);
              }
            },
          ),
          Center(
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.secondary, width: 3),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('Point camera at QR code',
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontSize: 14)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
