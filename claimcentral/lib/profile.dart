import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;
  final TextEditingController _nameController = TextEditingController(text: "John Doe");
  final TextEditingController _emailController = TextEditingController(text: "john.doe@email.com");
  final TextEditingController _dobController = TextEditingController(text: "1990-01-01");
  final TextEditingController _phoneController = TextEditingController(text: "+91 9876543210");
  final TextEditingController _addressController = TextEditingController(text: "123, Main Street, City");
  String _gender = "Male";
  bool _editingName = false;
  bool _editingEmail = false;
  bool _editingDob = false;
  bool _editingPhone = false;
  bool _editingAddress = false;
  bool _editingGender = false;

  final List<String> _genderOptions = ["Male", "Female", "Non-binary", "Prefer not to say", "Other"];

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  void _showChangePasswordDialog() {
    final oldPassController = TextEditingController();
    final newPassController = TextEditingController();
    final confirmPassController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent, // Transparent background
        elevation: 0,
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.symmetric(horizontal: 24),
        content: Center(
          child: Container(
            padding: EdgeInsets.all(22),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1.5), // Only black border
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Change Password",
                  style: TextStyle(
                    color: Color(0xFF2193b0),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 18),
                TextField(
                  controller: oldPassController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Old Password",
                    prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF2193b0)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.black, width: 1.2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFF2193b0), width: 2),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: newPassController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "New Password",
                    prefixIcon: Icon(Icons.lock, color: Color(0xFF2193b0)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.black, width: 1.2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFF2193b0), width: 2),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: confirmPassController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Confirm New Password",
                    prefixIcon: Icon(Icons.lock, color: Color(0xFF2193b0)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.black, width: 1.2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFF2193b0), width: 2),
                    ),
                  ),
                ),
                SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text("Cancel", style: TextStyle(color: Colors.black54)),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2193b0),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 2,
                      ),
                      child: Text("Enter"),
                      onPressed: () {
                        // TODO: Validate and change password
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required bool editing,
    required VoidCallback onEdit,
    required VoidCallback onSave,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: editing
                ? TextField(
                    controller: controller,
                    keyboardType: keyboardType,
                    maxLines: maxLines,
                    decoration: InputDecoration(
                      labelText: label,
                      prefixIcon: Icon(icon, color: Color(0xFF2193b0)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.black, width: 1.2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFF2193b0), width: 2),
                      ),
                      filled: false, // No fill color
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(icon, color: Color(0xFF2193b0)),
                      title: Text(
                        controller.text,
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      subtitle: Text(label),
                    ),
                  ),
          ),
          SizedBox(width: 8),
          editing
              ? IconButton(
                  icon: Icon(Icons.check_circle, color: Color(0xFF2193b0)),
                  onPressed: onSave,
                )
              : IconButton(
                  icon: Icon(Icons.edit, color: Color(0xFF2193b0)),
                  onPressed: onEdit,
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
            // Patterned circles for background
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
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Back Button
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
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
                    ),
                    SizedBox(height: 16),
                    // Profile Picture + Edit
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 54,
                          backgroundColor: Color(0xFF2193b0).withOpacity(0.12),
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : AssetImage('assets/logo.png') as ImageProvider,
                        ),
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: _pickProfileImage,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.all(6),
                              child: Icon(Icons.edit, color: Color(0xFF2193b0), size: 22),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Role (uneditable, no "uneditable" text)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.badge, color: Color(0xFF2193b0)),
                          SizedBox(width: 8),
                          Text(
                            "Employee", // Replace with actual role
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    // Editable fields with black borders, no fill
                    _buildEditableField(
                      label: "Name",
                      icon: Icons.person,
                      controller: _nameController,
                      editing: _editingName,
                      onEdit: () => setState(() => _editingName = true),
                      onSave: () => setState(() => _editingName = false),
                    ),
                    _buildEditableField(
                      label: "Email",
                      icon: Icons.email_outlined,
                      controller: _emailController,
                      editing: _editingEmail,
                      onEdit: () => setState(() => _editingEmail = true),
                      onSave: () => setState(() => _editingEmail = false),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    _buildEditableField(
                      label: "Date of Birth",
                      icon: Icons.cake_outlined,
                      controller: _dobController,
                      editing: _editingDob,
                      onEdit: () => setState(() => _editingDob = true),
                      onSave: () => setState(() => _editingDob = false),
                      keyboardType: TextInputType.datetime,
                    ),
                    // Gender dropdown
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: _editingGender
                                ? DropdownButtonFormField<String>(
                                    value: _gender,
                                    decoration: InputDecoration(
                                      labelText: "Gender",
                                      prefixIcon: Icon(Icons.wc, color: Color(0xFF2193b0)),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.black, width: 1.2),
                                      ),
                                      filled: false,
                                    ),
                                    items: _genderOptions.map((g) {
                                      return DropdownMenuItem(
                                        value: g,
                                        child: Text(g),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      if (val != null) setState(() => _gender = val);
                                    },
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black, width: 1.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: Icon(Icons.wc, color: Color(0xFF2193b0)),
                                      title: Text(
                                        _gender,
                                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                      ),
                                      subtitle: Text("Gender"),
                                    ),
                                  ),
                          ),
                          SizedBox(width: 8),
                          _editingGender
                              ? IconButton(
                                  icon: Icon(Icons.check_circle, color: Color(0xFF2193b0)),
                                  onPressed: () => setState(() => _editingGender = false),
                                )
                              : IconButton(
                                  icon: Icon(Icons.edit, color: Color(0xFF2193b0)),
                                  onPressed: () => setState(() => _editingGender = true),
                                ),
                        ],
                      ),
                    ),
                    _buildEditableField(
                      label: "Phone Number",
                      icon: Icons.phone,
                      controller: _phoneController,
                      editing: _editingPhone,
                      onEdit: () => setState(() => _editingPhone = true),
                      onSave: () => setState(() => _editingPhone = false),
                      keyboardType: TextInputType.phone,
                    ),
                    _buildEditableField(
                      label: "Address",
                      icon: Icons.location_on_outlined,
                      controller: _addressController,
                      editing: _editingAddress,
                      onEdit: () => setState(() => _editingAddress = true),
                      onSave: () => setState(() => _editingAddress = false),
                      maxLines: 2,
                    ),
                    SizedBox(height: 28),
                    // Change Password Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2193b0),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 4,
                          textStyle: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        icon: Icon(Icons.lock_reset),
                        label: Text("Change Password"),
                        onPressed: _showChangePasswordDialog,
                      ),
                    ),
                    SizedBox(height: 32),
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
