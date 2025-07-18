import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'approve.dart';

class ReimbursementPage extends StatefulWidget {
  const ReimbursementPage({super.key});

  @override
  State<ReimbursementPage> createState() => _ReimbursementPageState();
}

class _ReimbursementPageState extends State<ReimbursementPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();
  String? _selectedType;
  File? _selectedFile;
  String? _selectedFileName;

  final List<Map<String, dynamic>> _history = [
    {
      'amount': 1200,
      'type': 'TRAVEL',
      'status': 'Pending',
      'date': '2025-07-10'
    },
    {
      'amount': 500,
      'type': 'FOOD',
      'status': 'Approved',
      'date': '2025-06-22'
    },
  ];

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _selectedFileName = path.basename(result.files.single.path!);
      });
    }
  }

  Future<void> _pickCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _selectedFile = File(photo.path);
        _selectedFileName = path.basename(photo.path);
      });
    }
  }

  void _showApplyDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String? localSelectedType = _selectedType;
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            title: Text(
              'Apply for Reimbursement',
              style: TextStyle(
                color: Color(0xFF2193b0),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Amount
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Amount (INR)',
                      prefixIcon: Icon(Icons.currency_rupee, color: Color(0xFF2193b0)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // File and Camera Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2193b0),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: TextStyle(fontSize: 14),
                          ),
                          icon: Icon(Icons.attach_file, size: 18 , color: const Color.fromARGB(255, 0, 0, 0),),
                          label: Text('Attach File'),
                          onPressed: () async {
                            await _pickFile();
                            setState(() {});
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2193b0),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: TextStyle(fontSize: 14),
                          ),
                          icon: Icon(Icons.camera_alt_outlined, size: 18 , color: const Color.fromARGB(255, 0, 0, 0),),
                          label: Text('Click Picture'),
                          onPressed: () async {
                            await _pickCamera();
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                  if (_selectedFileName != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Row(
                        children: [
                          Icon(Icons.insert_drive_file, color: Color(0xFF2193b0)),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _selectedFileName!,
                              style: TextStyle(color: Colors.black87),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 16),
                  // Type Dropdown
                  DropdownButtonFormField<String>(
                    value: localSelectedType,
                    decoration: InputDecoration(
                      labelText: 'Type of Reimbursement',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.category, color: Color(0xFF2193b0)),
                    ),
                    items: [
                      'TRAVEL',
                      'FOOD',
                      'ACCOMODATION',
                      'OTHERS'
                    ].map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        localSelectedType = val;
                      });
                      _selectedType = val;
                    },
                  ),
                  SizedBox(height: 16),
                  // Comments Field (at the bottom)
                  TextField(
                    controller: _commentsController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Comments',
                      labelStyle: TextStyle(color: Colors.black87),
                      prefixIcon: Icon(Icons.comment, color: Color(0xFF2193b0)),
                      filled: true,
                      fillColor: Color(0xFFe0eafc).withOpacity(0.18),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFF2193b0), width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('Cancel', style: TextStyle(color: Colors.black54)),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2193b0),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Enter'),
                onPressed: () {
                  // TODO: Validate and submit reimbursement
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
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
            colors: [
              Color(0xFFe0eafc),
              Color(0xFF2193b0),
            ],
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
                    // Apply & Approve Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.black, width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.95),
                              foregroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: _showApplyDialog,
                            child: Text(
                              'Apply',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 18),
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.black, width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Colors.white.withOpacity(0.95),
                              foregroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ApprovePage()),
                            );
                            },
                            child: Text(
                              'Approve',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 18),
                    Divider(
                      color: Colors.black,
                      thickness: 1.5,
                    ),
                    SizedBox(height: 18),
                    // My History Container
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.97),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 18,
                            offset: Offset(0, 8),
                          ),
                        ],
                        border: Border.all(
                          color: Color(0xFF2193b0).withOpacity(0.18),
                          width: 1.6,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My history',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2193b0),
                            ),
                          ),
                          SizedBox(height: 14),
                          _history.isEmpty
                              ? Text(
                                  'No reimbursements yet.',
                                  style: TextStyle(color: Colors.black54),
                                )
                              : ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: _history.length,
                                  separatorBuilder: (context, idx) => Divider(),
                                  itemBuilder: (context, idx) {
                                    final item = _history[idx];
                                    return ListTile(
                                      leading: Icon(
                                        Icons.receipt_long,
                                        color: Color(0xFF2193b0),
                                      ),
                                      title: Text(
                                        '${item['type']} - ₹${item['amount']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Status: ${item['status']} | Date: ${item['date']}',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 13,
                                        ),
                                      ),
                                    );
                                  },
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
