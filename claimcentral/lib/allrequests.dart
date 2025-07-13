import 'package:flutter/material.dart';

class AllRequestPage extends StatelessWidget {
  AllRequestPage({Key? key}) : super(key: key);

  // Sample data for demonstration
  final List<Map<String, dynamic>> requests = const [
    {
      "name": "Alice Smith",
      "amount": 1500,
      "type": "TRAVEL",
      "date": "2025-07-10",
      "details": "Flight to Mumbai for client meeting.",
      "status": "Pending"
    },
    {
      "name": "Bob Johnson",
      "amount": 800,
      "type": "FOOD",
      "date": "2025-07-09",
      "details": "Team lunch with clients.",
      "status": "Pending"
    },
    {
      "name": "Carol White",
      "amount": 1200,
      "type": "ACCOMODATION",
      "date": "2025-07-08",
      "details": "Hotel stay for conference.",
      "status": "Pending"
    },
  ];

  void _showRequestDialog(BuildContext context, Map<String, dynamic> req) {
    final TextEditingController commentController = TextEditingController();
    bool isDisapprove = false;
    final ValueNotifier<bool> disapproveNotifier = ValueNotifier(false);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.symmetric(horizontal: 24),
          content: Center(
            child: Container(
              padding: EdgeInsets.all(22),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1.5),
                borderRadius: BorderRadius.circular(18),
                color: Colors.white,
              ),
              width: 370,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Upper half: Details
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Request Details",
                        style: TextStyle(
                          color: Color(0xFF2193b0),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 10),
                      _detailRow("Employee", req["name"]),
                      _detailRow("Amount", "₹${req["amount"]}"),
                      _detailRow("Type", req["type"]),
                      _detailRow("Date", req["date"]),
                      _detailRow("Purpose", req["details"]),
                      SizedBox(height: 10),
                    ],
                  ),
                  Divider(thickness: 1.2, color: Colors.black12),
                  SizedBox(height: 8),
                  // Admin comment
                  TextField(
                    controller: commentController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Admin Comment",
                      prefixIcon: Icon(Icons.comment, color: Color(0xFF2193b0)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.black, width: 1.2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFF2193b0), width: 2),
                      ),
                      filled: false,
                    ),
                  ),
                  SizedBox(height: 10),
                  // Approve/Disapprove buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Disapprove
                      ValueListenableBuilder<bool>(
                        valueListenable: disapproveNotifier,
                        builder: (context, disapprove, _) => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[700],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text("Disapprove"),
                          onPressed: () {
                            setState(() {
                              isDisapprove = true;
                            });
                            if (commentController.text.trim().isEmpty) {
                              // Show error if comment is empty
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Comment is required for disapproval."),
                                  backgroundColor: Colors.red[700],
                                ),
                              );
                            } else {
                              Navigator.pop(context);
                              // TODO: Handle disapproval logic with commentController.text
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 12),
                      // Approve
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2193b0),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text("Approve"),
                        onPressed: () {
                          // Approval comment is optional
                          Navigator.pop(context);
                          // TODO: Handle approval logic with commentController.text (optional)
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
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
                    // Requests List
                    Expanded(
                      child: ListView.builder(
                        itemCount: requests.length,
                        itemBuilder: (context, idx) {
                          final req = requests[idx];
                          return GestureDetector(
                            onTap: () => _showRequestDialog(context, req),
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
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
                                    Icon(Icons.account_circle_outlined, color: Color(0xFF2193b0), size: 34),
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
                                    Icon(Icons.arrow_forward_ios, color: Color(0xFF2193b0), size: 20),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
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
