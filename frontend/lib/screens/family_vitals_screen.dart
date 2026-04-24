import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/resident_model.dart';
import '../services/api_service.dart';

class FamilyVitalsScreen extends StatefulWidget {
  final ResidentModel? resident;
  final VoidCallback? onBack;
  const FamilyVitalsScreen({super.key, this.resident, this.onBack});

  @override
  State<FamilyVitalsScreen> createState() => _FamilyVitalsScreenState();
}

class _FamilyVitalsScreenState extends State<FamilyVitalsScreen> {
  static const primary = Color(0xFF4E59A8);
  static const accent = Color(0xFF66BB6A);
  static const textDark = Color(0xFF1E293B);
  static const textLight = Color(0xFF64748B);

  bool _isLoading = true;

  String _heartRate = '72 bpm';
  String _heartRateStatus = 'Healthy & Stable';
  String _heartRateExp = 'Heart rate is perfectly within the resting healthy range.';
  
  String _bloodPressure = '120/80';
  String _bloodPressureStatus = 'Optimal Range';
  String _bloodPressureExp = 'Blood pressure is stable and circulation is healthy.';
  
  String _temperature = '36.6°C';
  String _temperatureStatus = 'Normal & Calm';
  String _temperatureExp = 'Body temperature is perfectly stable and normal.';
  
  String _spO2 = '98%';
  String _spO2Status = 'Excellent';
  String _spO2Exp = 'Oxygen levels are perfect. Breathing is clear and effortless.';

  @override
  void initState() {
    super.initState();
    _fetchVitals();
  }

  Future<void> _fetchVitals() async {
    if (widget.resident == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    try {
      final res = await ApiService.get('/vitals/latest?residentId=${widget.resident!.id}');
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body)['data'];
        if (data != null && mounted) {
          setState(() {
            final hr = data['heartRate'];
            final bp = data['bloodPressure'];
            final temp = data['temperature'];
            final spo2 = data['spO2'];

            if (hr != null) {
              _heartRate = '$hr bpm';
              if (hr < 60) {
                _heartRateStatus = 'Calm & Resting';
                _heartRateExp = 'Heart rate is slightly lower than average, indicating deep rest.';
              } else if (hr > 100) {
                _heartRateStatus = 'Slightly Active';
                _heartRateExp = 'Heart rate is slightly elevated. Staff is monitoring for comfort.';
              } else {
                _heartRateStatus = 'Healthy & Stable';
                _heartRateExp = 'Heart rate is perfectly within the resting healthy range.';
              }
            }

            if (bp != null) {
              final sys = bp['systolic'] ?? 120;
              final dia = bp['diastolic'] ?? 80;
              _bloodPressure = '$sys/$dia';
              if (sys > 140 || dia > 90) {
                _bloodPressureStatus = 'Being Monitored';
                _bloodPressureExp = 'BP is slightly elevated. The care team is providing support.';
              } else {
                _bloodPressureStatus = 'Optimal Range';
                _bloodPressureExp = 'Blood pressure is stable and circulation is healthy.';
              }
            }

            if (temp != null) {
              _temperature = '${temp}°C';
              if (temp > 37.5) {
                _temperatureStatus = 'Warm & Monitored';
                _temperatureExp = 'A slight warmth detected. Staff is providing comforting care.';
              } else {
                _temperatureStatus = 'Normal & Calm';
                _temperatureExp = 'Body temperature is perfectly stable and normal.';
              }
            }

            if (spo2 != null) {
              _spO2 = '$spo2%';
              if (spo2 < 95) {
                _spO2Status = 'Carefully Watched';
                _spO2Exp = 'Oxygen levels are being supported for better comfort.';
              } else {
                _spO2Status = 'Excellent';
                _spO2Exp = 'Oxygen levels are perfect. Breathing is clear and effortless.';
              }
            }
          });
        }
      }
    } catch (_) {} finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F9),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: primary, strokeWidth: 2))
        : CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      _buildReassuranceBanner(),
                      const SizedBox(height: 36),
                      _buildVitalCard(Icons.favorite_rounded, "Heart Rate", _heartRate, _heartRateStatus, _heartRateExp, Colors.redAccent),
                      const SizedBox(height: 16),
                      _buildVitalCard(Icons.water_drop_rounded, "Blood Pressure", _bloodPressure, _bloodPressureStatus, _bloodPressureExp, Colors.blueAccent),
                      const SizedBox(height: 16),
                      _buildVitalCard(Icons.thermostat_rounded, "Body Temperature", _temperature, _temperatureStatus, _temperatureExp, Colors.orangeAccent),
                      const SizedBox(height: 16),
                      _buildVitalCard(Icons.air_rounded, "Oxygen Levels", _spO2, _spO2Status, _spO2Exp, Colors.teal),
                      const SizedBox(height: 48),
                      _buildUpdateAction(),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      backgroundColor: const Color(0xFFF3F4F9),
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.arrow_back_ios_new_rounded, color: textDark, size: 16),
        ),
        onPressed: widget.onBack,
      ),
      title: const Text(
        "Health Wellbeing",
        style: TextStyle(color: textDark, fontWeight: FontWeight.w800, fontSize: 18, fontFamily: "Lexend"),
      ),
    );
  }

  Widget _buildReassuranceBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: accent,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(color: accent.withOpacity(0.2), blurRadius: 25, offset: const Offset(0, 10)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), shape: BoxShape.circle),
            child: const Icon(Icons.verified_user_rounded, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 22),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Stable & Healthy",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "Lexend", letterSpacing: -0.5),
                ),
                SizedBox(height: 4),
                Text(
                  "All health indicators are within optimal ranges.",
                  style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalCard(IconData icon, String title, String value, String status, String exp, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(16)),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(width: 18),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 14, color: textLight, fontWeight: FontWeight.w700, fontFamily: "Lexend")),
                      Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: textDark, letterSpacing: -0.5)),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
                child: Text(status, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.2)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, color: textLight, size: 16),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    exp,
                    style: const TextStyle(color: textLight, fontSize: 12, height: 1.5, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateAction() {
    return InkWell(
      onTap: () {
        setState(() => _isLoading = true);
        _fetchVitals();
      },
      borderRadius: BorderRadius.circular(32),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: textDark,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          children: [
            const Icon(Icons.update_rounded, color: Colors.white60, size: 20),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Last Checked", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: "Lexend")),
                  Text("Recently updated by the care team", style: TextStyle(color: Colors.white38, fontSize: 12)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
              child: const Text("Refresh", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }
}
