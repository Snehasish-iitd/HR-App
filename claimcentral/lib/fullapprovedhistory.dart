import 'package:flutter/material.dart';

class FullApprovedHistoryPage extends StatefulWidget {
  const FullApprovedHistoryPage({Key? key}) : super(key: key);

  @override
  State<FullApprovedHistoryPage> createState() => _FullApprovedHistoryPageState();
}

class _FullApprovedHistoryPageState extends State<FullApprovedHistoryPage> {
  // Sample approved requests data
  final List<Map<String, dynamic>> _allApproved = [
    {
      "name": "Carol White",
      "amount": 1200,
      "type": "ACCOMODATION",
      "approved_date": "2025-07-10 14:30"
    },
    {
      "name": "David Brown",
      "amount": 500,
      "type": "OTHERS",
      "approved_date": "2025-07-09 10:15"
    },
    {
      "name": "Eve Black",
      "amount": 750,
      "type": "TRAVEL",
      "approved_date": "2025-07-08 09:00"
    },
    {
      "name": "Frank Green",
      "amount": 300,
      "type": "FOOD",
      "approved_date": "2025-07-07 18:45"
    },
  ];

  DateTime? _startDate;
  DateTime? _endDate;

  List<Map<String, dynamic>> get _filteredApproved {
    if (_startDate == null && _endDate == null) return _allApproved;
    return _allApproved.where((item) {
      final dt = DateTime.parse(item['approved_date'].replaceFirst(' ', 'T'));
      if (_startDate != null && dt.isBefore(_startDate!)) return false;
      if (_endDate != null && dt.isAfter(_endDate!)) return false;
      return true;
    }).toList();
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(Duration(days: 365)),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF2193b0),
              onPrimary: Colors.white,
              surface: Color(0xFFe0eafc),
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  Widget _buildApprovedTile(Map<String, dynamic> req) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFe0eafc), Color(0xFF2193b0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.all(2),
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.98),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Icon(Icons.verified, color: Colors.green[600], size: 34),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    req["name"],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    req["type"],
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    "Approved: ${req["approved_date"]}",
                    style: TextStyle(
                      color: Colors.black38,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              "₹${req["amount"]}",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF2193b0),
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Signature background
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFe0eafc), Color(0xFF2193b0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Patterned circles
            Positioned(
              top: -40,
              left: -40,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.23),
                ),
              ),
            ),
            Positioned(
              top: 120,
              right: -60,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.09),
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              left: 20,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF2193b0).withOpacity(0.13),
                ),
              ),
            ),
            Positioned(
              bottom: 80,
              right: -30,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.18),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back Button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.92),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Color(0xFF2193b0), size: 28),
                        onPressed: () => Navigator.pop(context),
                        tooltip: 'Back',
                      ),
                    ),
                    SizedBox(height: 24),
                    // Filter Row
                    Row(
                      children: [
                        Text(
                          "Approved Requests",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                            color: Color(0xFF2193b0),
                          ),
                        ),
                        Spacer(),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2193b0),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 2,
                            textStyle: TextStyle(fontSize: 14),
                          ),
                          icon: Icon(Icons.filter_alt, size: 18),
                          label: Text("Filter"),
                          onPressed: _pickDateRange,
                        ),
                      ],
                    ),
                    if (_startDate != null && _endDate != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Showing: ${_startDate!.toLocal().toString().split(' ')[0]} to ${_endDate!.toLocal().toString().split(' ')[0]}",
                          style: TextStyle(color: Colors.black54, fontSize: 13),
                        ),
                      ),
                    SizedBox(height: 18),
                    // Approved Requests List
                    Expanded(
                      child: _filteredApproved.isEmpty
                          ? Center(
                              child: Text(
                                "No approved requests in this range.",
                                style: TextStyle(color: Colors.black45, fontSize: 16),
                              ),
                            )
                          : ListView.builder(
                              itemCount: _filteredApproved.length,
                              itemBuilder: (context, idx) =>
                                  _buildApprovedTile(_filteredApproved[idx]),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
