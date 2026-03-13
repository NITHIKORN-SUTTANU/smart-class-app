import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../constants/app_theme.dart';
import 'checkin_screen.dart';
import 'finish_class_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning';
    if (h < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('EEEE, d MMM yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
              child: _Header(greeting: _greeting, dateStr: dateStr)),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _ActionCard(
                  icon: Icons.login_rounded,
                  stepLabel: 'STEP 1',
                  title: 'Check In',
                  subtitle: 'Start your class session',
                  description: 'Scan QR code, verify GPS & share your mood',
                  accentColor: AppColors.primary,
                  lightColor: AppColors.primaryLight,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CheckInScreen()),
                  ),
                ),
                const SizedBox(height: 16),
                _ActionCard(
                  icon: Icons.task_alt_rounded,
                  stepLabel: 'STEP 2',
                  title: 'Finish Class',
                  subtitle: 'Complete your learning session',
                  description: 'Reflect on what you learned and give feedback',
                  accentColor: AppColors.secondary,
                  lightColor: AppColors.secondaryLight,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const FinishClassScreen()),
                  ),
                ),
                const SizedBox(height: 32),
                const _HowItWorks(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Header ───────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final String greeting;
  final String dateStr;
  const _Header({required this.greeting, required this.dateStr});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF3730A3),
            AppColors.primary,
            AppColors.primaryMid,
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Brand row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(51),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.school_rounded,
                        color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Smart Class',
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700)),
                      Text('Check-in System',
                          style: GoogleFonts.poppins(
                              color: Colors.white60,
                              fontSize: 12,
                              fontWeight: FontWeight.w400)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Text('$greeting 👋',
                  style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w400)),
              const SizedBox(height: 4),
              Text('Ready for class?',
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      height: 1.2)),
              const SizedBox(height: 18),
              // Date chip
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(38),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.calendar_today_rounded,
                        color: Colors.white70, size: 15),
                    const SizedBox(width: 8),
                    Text(dateStr,
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Action Card ──────────────────────────────────────────────────────────────

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String stepLabel;
  final String title;
  final String subtitle;
  final String description;
  final Color accentColor;
  final Color lightColor;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.stepLabel,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.accentColor,
    required this.lightColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: lightColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withAlpha(76),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Icon(icon, color: Colors.white, size: 26),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: accentColor.withAlpha(31),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(stepLabel,
                                style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: accentColor,
                                    letterSpacing: 0.8)),
                          ),
                          const SizedBox(height: 6),
                          Text(title,
                              style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary)),
                          Text(subtitle,
                              style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded,
                        color: accentColor, size: 16),
                  ],
                ),
              ),
              // Bottom info strip
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 13),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded,
                        size: 14, color: AppColors.textHint),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(description,
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.textSecondary)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── How It Works ─────────────────────────────────────────────────────────────

class _HowItWorks extends StatelessWidget {
  const _HowItWorks();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('How it works',
            style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const SizedBox(height: 14),
        const _Step(
          icon: Icons.badge_rounded,
          color: AppColors.primary,
          title: 'Enter Student ID',
          desc: 'Identify yourself before joining the class',
        ),
        const _Step(
          icon: Icons.qr_code_scanner_rounded,
          color: AppColors.qrPurple,
          title: 'Scan QR Code',
          desc: 'Scan the classroom QR code to verify attendance',
        ),
        const _Step(
          icon: Icons.location_on_rounded,
          color: AppColors.gpsTeal,
          title: 'GPS Verification',
          desc: 'Confirm you are physically in the classroom',
        ),
        const _Step(
          icon: Icons.psychology_rounded,
          color: AppColors.secondary,
          title: 'Reflection',
          desc: 'Share your mood and what you expect or learned',
          isLast: true,
        ),
      ],
    );
  }
}

class _Step extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String desc;
  final bool isLast;

  const _Step({
    required this.icon,
    required this.color,
    required this.title,
    required this.desc,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withAlpha(26),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            if (!isLast)
              Container(width: 2, height: 24, color: AppColors.border),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(title,
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                Text(desc,
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
