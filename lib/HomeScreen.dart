import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vulnerability Overview',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[50],
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.indigo[800],
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Colors.grey[800],
          ),
        ),
      ),
      home: VulnerabilityOverviewPage(),
    );
  }
}

class VulnerabilityOverviewPage extends StatefulWidget {
  const VulnerabilityOverviewPage({super.key});

  @override
  _VulnerabilityOverviewPageState createState() => _VulnerabilityOverviewPageState();
}

class _VulnerabilityOverviewPageState extends State<VulnerabilityOverviewPage> {
  final TextEditingController _cveController = TextEditingController();
  String? _selectedAssetType;
  double? _acmValue;
  String? _severity;
  double? _cvssScore;
  double? _epssScore;
  String? _priority;
  double _priorityScore = 0;
  double _cvssWeight = 0.6;
  double _epssWeight = 0.4;
  bool _isLoading = false;

  final Map<String, double> _assetTypes = {
    'Database with sensitive info': 2.0,
    'Internal server': 1.5,
    'E-commerce website': 1.3,
    'Public blog': 1.0,
  };

  Future<void> _fetchVulnerabilityData() async {
    if (_isLoading) return;

    final cveCode = _cveController.text.trim();
    if (cveCode.isEmpty || _selectedAssetType == null) {
      setState(() => _severity = 'Please enter a CVE code and select an asset type.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      print('Fetching data for $cveCode...');
      final cvssResponse = await http.get(Uri.parse('https://cve.circl.lu/api/cve/$cveCode'));
      if (cvssResponse.statusCode != 200) throw Exception('Failed to load CVSS data');
      final cvssData = json.decode(cvssResponse.body);
      final cvssScore = cvssData['containers']['cna']?.containsKey('metrics') == false
          ? cvssData['containers']['adp'][0]['metrics'][0]['cvssV3_1']['baseScore']
          : (cvssData['containers']['cna']['metrics'][0]['cvssV3_1']['baseScore'] as num).toDouble();


      final epssResponse = await http.get(Uri.parse('https://api.first.org/data/v1/epss?cve=$cveCode'));
      if (epssResponse.statusCode != 200) throw Exception('Failed to load EPSS data');
      final epssData = json.decode(epssResponse.body);
      final epssScore = double.parse(epssData['data'][0]['epss']);

      final normalizedCvss = cvssScore / 10.0;
      final priorityScore = _acmValue! * (_cvssWeight * normalizedCvss + _epssWeight * epssScore);

      final priority = _calculatePriority(priorityScore);
      final severityLabel = _getSeverityLabel(cvssScore);

      setState(() {
        _cvssScore = cvssScore;
        _epssScore = epssScore;
        _severity = 'Severity: $severityLabel (${cvssScore.toStringAsFixed(1)})';
        _priority = priority;
        _priorityScore = priorityScore;
      });
    } catch (e) {
      setState(() => _severity = 'Error: ${e.toString().replaceAll('Exception: ', '')}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _calculatePriority(double score) {
    if (score > 1.5) return 'Critical – Fix ASAP';
    if (score > 1.0) return 'High – Fix Soon';
    if (score > 0.5) return 'Medium – Fix Later';
    return 'Low – Monitor';
  }

  String _getSeverityLabel(double cvssScore) {
    if (cvssScore >= 9.0) return 'Critical';
    if (cvssScore >= 7.0) return 'High';
    if (cvssScore >= 4.0) return 'Medium';
    return 'Low';
  }

  Color _getPriorityColor() {
    switch (_priority?.split(' ')[0]) {
      case 'Critical':
        return Colors.red;
      case 'High':
        return Colors.orange;
      case 'Medium':
        return Colors.amber;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vulnerability Overview'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _cveController,
              decoration: InputDecoration(
                labelText: 'CVE Identifier',
                prefixIcon: Icon(Icons.search, color: Colors.indigo),
                hintText: 'e.g., CVE-2023-12345',
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Asset Type',
                prefixIcon: Icon(Icons.storage, color: Colors.indigo),
              ),
              value: _selectedAssetType,
              items: _assetTypes.entries.map((e) => DropdownMenuItem(
                value: e.key,
                child: Text(e.key, style: Theme.of(context).textTheme.bodyMedium),
              )).toList(),
              onChanged: (value) => setState(() {
                _selectedAssetType = value;
                _acmValue = _assetTypes[value];
              }),
            ),
            const SizedBox(height: 25),
            _buildWeightSliders(),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              icon: _isLoading 
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Icon(Icons.analytics, size: 24),
              label: Text(_isLoading ? 'Analyzing...' : 'Analyze Vulnerability'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _isLoading ? null : _fetchVulnerabilityData,
            ),
            if (_severity != null) ...[
              const SizedBox(height: 30),
              _buildResultsCard(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWeightSliders() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Adjust Scoring Weights', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text('CVSS', style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.w500)),
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: Colors.indigo,
                      thumbColor: Colors.indigo,
                      overlayColor: Colors.indigo.withOpacity(0.2),
                    ),
                    child: Slider(
                      value: _cvssWeight,
                      min: 0,
                      max: 1,
                      divisions: 10,
                      label: _cvssWeight.toStringAsFixed(2),
                      onChanged: (v) => setState(() {
                        _cvssWeight = v;
                        _epssWeight = 1 - v;
                      }),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text('EPSS', style: TextStyle(color: Colors.purple, fontWeight: FontWeight.w500)),
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: Colors.purple,
                      thumbColor: Colors.purple,
                      overlayColor: Colors.purple.withOpacity(0.2),
                    ),
                    child: Slider(
                      value: _epssWeight,
                      min: 0,
                      max: 1,
                      divisions: 10,
                      label: _epssWeight.toStringAsFixed(2),
                      onChanged: (v) => setState(() {
                        _epssWeight = v;
                        _cvssWeight = 1 - v;
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResultsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: _getPriorityColor(), size: 28),
                const SizedBox(width: 12),
                Text('Assessment Results', 
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: _getPriorityColor())),
              ],
            ),
            const Divider(height: 30, thickness: 1),
            _buildResultRow('CVSS Score', _cvssScore?.toStringAsFixed(1) ?? '-', Icons.speed),
            _buildResultRow('EPSS Score', _epssScore?.toStringAsFixed(3) ?? '-', Icons.trending_up),
            _buildResultRow('Priority Score', _priorityScore?.toStringAsFixed(2) ?? '-', Icons.score),
            _buildResultRow('Severity Level', _severity?.split(': ')[1] ?? '-', Icons.layers),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: _getPriorityColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _getPriorityColor().withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.priority_high, color: _getPriorityColor()),
                  const SizedBox(width: 12),
                  Text(_priority ?? 'No priority calculated',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _getPriorityColor(),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
          Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.indigo[800],
          )),
        ],
      ),
    );
  }
}