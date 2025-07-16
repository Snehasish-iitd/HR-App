import 'package:flutter/material.dart';
import 'allrequests.dart';
import 'fullapprovedhistory.dart';

class ApprovePage extends StatelessWidget {
  const ApprovePage({super.key});

  // Sample data for demonstration
  final List<Map<String, dynamic>> requests = const [
    {"name": "Alice Smith", "amount": 1500, "type": "TRAVEL"},
    {"name": "Bob Johnson", "amount": 800, "type": "FOOD"},
  ];

  final List<Map<String, dynamic>> approvedRequests = const [
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
  ];

  Widget _buildContainer({
    required String title,
    required VoidCallback onArrowTap,
    required List<Widget> children,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFe0eafc), Color(0xFF2193b0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.all(2),
        padding: EdgeInsets.symmetric(horizontal: 22, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.98),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                    color: Color(0xFF2193b0),
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: onArrowTap,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFe0eafc),
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(6),
                    child: Icon(Icons.arrow_forward_ios, color: Color(0xFF2193b0), size: 20),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildRequestTile(Map<String, dynamic> req) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(Icons.account_circle_outlined, color: Color(0xFF2193b0), size: 28),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  req["name"],
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black87),
                ),
                Text(
                  req["type"],
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ],
            ),
          ),
          Text(
            "₹${req["amount"]}",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildApprovedTile(Map<String, dynamic> req) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(Icons.verified, color: Colors.green[600], size: 28),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  req["name"],
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black87),
                ),
                Text(
                  req["type"],
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                ),
                Text(
                  "Approved: ${req["approved_date"]}",
                  style: TextStyle(color: Colors.black38, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            "₹${req["amount"]}",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 15),
          ),
        ],
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
                    // Two equal containers
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: _buildContainer(
                              title: "Requests",
                              onArrowTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AllRequestPage()));
                              },
                              children: requests
                                  .map((req) => _buildRequestTile(req))
                                  .toList(),
                            ),
                          ),
                          SizedBox(height: 18),
                          Expanded(
                            child: _buildContainer(
                              title: "Approved",
                              onArrowTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => FullApprovedHistoryPage()));
                              },
                              children: approvedRequests
                                  .map((req) => _buildApprovedTile(req))
                                  .toList(),
                            ),
                          ),
                        ],
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
