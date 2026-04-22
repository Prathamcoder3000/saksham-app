import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../l10n/app_localizations.dart';
import '../services/api_service.dart';
import '../models/resident_model.dart';
import 'dart:convert';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  bool _isLoading = true;
  List<ResidentModel> _residents = [];
  ResidentModel? _selectedResident;
  List<dynamic> _vitalsHistory = [];
  Map<String, dynamic> _summaryData = {};
  List<dynamic> _staffActivity = [];

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    try {
      final residentsRes = await ApiService.get('/residents');
      final summaryRes = await ApiService.get('/reports/summary');

      if (residentsRes.statusCode == 200 && summaryRes.statusCode == 200) {
        final residentsData = jsonDecode(residentsRes.body)['data'] as List;
        setState(() {
          _residents = residentsData.map((r) => ResidentModel.fromJson(r)).toList();
          _summaryData = jsonDecode(summaryRes.body)['data'];
          _staffActivity = []; // default safe empty
          if (_residents.isNotEmpty) {
            _selectedResident = _residents.first;
            _fetchVitalsHistory(_selectedResident!.id);
          } else {
            _isLoading = false;
          }
        });

        // Fetch staff activity separately — safe failure
        try {
          final staffRes = await ApiService.get('/reports/staff-activity');
          if (staffRes.statusCode == 200) {
            final parsed = jsonDecode(staffRes.body)['data'];
            if (mounted && parsed is List) {
              setState(() => _staffActivity = parsed);
            }
          }
        } catch (_) {
          // Staff activity is optional — fail silently
        }
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchVitalsHistory(String residentId) async {
    try {
      final res = await ApiService.get('/residents/$residentId/vitals/history');
      if (res.statusCode == 200) {
        setState(() {
          _vitalsHistory = jsonDecode(res.body)['data'];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(l10n.analytics, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 RESIDENT SELECTOR
                if (_residents.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
                    ),
                    child: DropdownButton<ResidentModel>(
                      value: _selectedResident,
                      isExpanded: true,
                      underline: const SizedBox(),
                      onChanged: (ResidentModel? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedResident = newValue;
                            _isLoading = true;
                          });
                          _fetchVitalsHistory(newValue.id);
                        }
                      },
                      items: _residents.map<DropdownMenuItem<ResidentModel>>((ResidentModel r) {
                        return DropdownMenuItem<ResidentModel>(
                          value: r,
                          child: Text(r.name),
                        );
                      }).toList(),
                    ),
                  ),
                
                const SizedBox(height: 24),

                _sectionTitle(l10n.vitalsTrends),
                _buildLineChart(),
                const SizedBox(height: 24),
                
                _sectionTitle(l10n.staffActivity),
                _buildBarChart(),
                const SizedBox(height: 24),
                
                _sectionTitle(l10n.medicineCompliance),
                _buildPieChart(),
                const SizedBox(height: 30),
              ],
            ),
          ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
    );
  }

  Widget _buildLineChart() {
    if (_vitalsHistory.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: const Center(child: Text("No vitals data available")),
      );
    }

    // Map history to spots
    List<FlSpot> spots = [];
    for (int i = 0; i < _vitalsHistory.length; i++) {
        double hr = (_vitalsHistory[i]['heartRate'] ?? 70).toDouble();
        spots.add(FlSpot(i.toDouble(), hr));
    }

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots.reversed.toList(),
              isCurved: true,
              color: Colors.blue,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.1)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    if (_staffActivity.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: const Center(child: Text("No staff activity recorded yet.")),
      );
    }
    
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
      child: BarChart(
        BarChartData(
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(sideTitles: SideTitles(
                showTitles: true, 
                getTitlesWidget: (v, m) {
                    if (v.toInt() < _staffActivity.length) {
                        final name = _staffActivity[v.toInt()]['name'];
                        return Text(name.split(' ')[0], style: const TextStyle(fontSize: 8));
                    }
                    return const Text('');
                }
            )),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
          barGroups: _staffActivity.asMap().entries.map((e) {
              return BarChartGroupData(x: e.key, barRods: [
                  BarChartRodData(toY: (e.value['count'] as int).toDouble(), color: Colors.teal, width: 14)
              ]);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    double adherence = (_summaryData['adherenceRate'] ?? 85).toDouble();
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: adherence, 
              color: Colors.blue, 
              title: '${adherence.toInt()}%', 
              radius: 50, 
              titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
            ),
            PieChartSectionData(
              value: 100 - adherence, 
              color: Colors.grey[300], 
              title: '${(100 - adherence).toInt()}%', 
              radius: 40, 
              titleStyle: const TextStyle(color: Colors.black54)
            ),
          ],
        ),
      ),
    );
  }
}
