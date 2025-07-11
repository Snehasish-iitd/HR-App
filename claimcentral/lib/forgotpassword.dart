import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  bool expandChangePassword = false;

  // Controllers for fields (optional, for further logic)
  final TextEditingController emailController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFe0eafc), // Sky blue
              Color.fromARGB(255, 22, 98, 117), // Deep blue
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Visible geometric pattern overlay (same as login)
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
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Back button and title
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: Color(0xFF1b2a49), size: 28),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Forgot Password',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1b2a49),
                              letterSpacing: 1.1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 36),
                      // Card 1: Send Code
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(2.5),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF6dd5ed),
                              Color.fromARGB(255, 25, 110, 131),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: Color.fromARGB(255, 10, 69, 83), width: 2.5),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(26),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.97),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 24,
                                offset: Offset(0, 16),
                              ),
                            ],
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.97),
                                Color(0xFFe0eafc).withOpacity(0.18),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Send Reset Code',
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2193b0),
                                ),
                              ),
                              SizedBox(height: 16),
                              TextField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(color: Colors.black87),
                                  prefixIcon: Icon(Icons.mail_outline, color: Color(0xFF2193b0), size: 22),
                                  filled: true,
                                  fillColor: Color(0xFFe0eafc).withOpacity(0.18),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(color: Color(0xFF2193b0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(color: Color(0xFF2193b0), width: 2),
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              SizedBox(height: 18),
                              SizedBox(
                                width: double.infinity,
                                height: 46,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF2193b0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    elevation: 3,
                                    textStyle: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  icon: Icon(Icons.send, color: Colors.white, size: 20),
                                  label: Text(
                                    'Send Code',
                                    style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                  onPressed: () {
                                    // TODO: Implement send code logic
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 28),
                      // Card 2: Change Password (Expandable)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(2.5),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF6dd5ed),
                              Color.fromARGB(255, 25, 110, 131),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: Color.fromARGB(255, 10, 69, 83), width: 2.5),
                        ),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          padding: EdgeInsets.all(26),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.97),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 24,
                                offset: Offset(0, 16),
                              ),
                            ],
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.97),
                                Color(0xFFe0eafc).withOpacity(0.18),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    expandChangePassword = !expandChangePassword;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.lock_reset,
                                      color: Color(0xFF2193b0),
                                      size: 24,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Change your password',
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2193b0),
                                      ),
                                    ),
                                    Spacer(),
                                    Icon(
                                      expandChangePassword
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: Color(0xFF2193b0),
                                      size: 28,
                                    ),
                                  ],
                                ),
                              ),
                              // Expansion: show fields if expanded
                              AnimatedCrossFade(
                                duration: Duration(milliseconds: 300),
                                crossFadeState: expandChangePassword
                                    ? CrossFadeState.showSecond
                                    : CrossFadeState.showFirst,
                                firstChild: SizedBox(height: 0),
                                secondChild: Column(
                                  children: [
                                    SizedBox(height: 18),
                                    TextField(
                                      controller: codeController,
                                      decoration: InputDecoration(
                                        labelText: 'Code',
                                        labelStyle: TextStyle(color: Colors.black87),
                                        prefixIcon: Icon(Icons.vpn_key, color: Color(0xFF2193b0), size: 22),
                                        filled: true,
                                        fillColor: Color(0xFFe0eafc).withOpacity(0.18),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(14),
                                          borderSide: BorderSide(color: Color(0xFF2193b0)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(14),
                                          borderSide: BorderSide(color: Color(0xFF2193b0), width: 2),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 14),
                                    TextField(
                                      controller: newPasswordController,
                                      decoration: InputDecoration(
                                        labelText: 'New Password',
                                        labelStyle: TextStyle(color: Colors.black87),
                                        prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF2193b0), size: 22),
                                        filled: true,
                                        fillColor: Color(0xFFe0eafc).withOpacity(0.18),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(14),
                                          borderSide: BorderSide(color: Color(0xFF2193b0)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(14),
                                          borderSide: BorderSide(color: Color(0xFF2193b0), width: 2),
                                        ),
                                      ),
                                      obscureText: true,
                                    ),
                                    SizedBox(height: 14),
                                    TextField(
                                      controller: confirmPasswordController,
                                      decoration: InputDecoration(
                                        labelText: 'Confirm New Password',
                                        labelStyle: TextStyle(color: Colors.black87),
                                        prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF2193b0), size: 22),
                                        filled: true,
                                        fillColor: Color(0xFFe0eafc).withOpacity(0.18),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(14),
                                          borderSide: BorderSide(color: Color(0xFF2193b0)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(14),
                                          borderSide: BorderSide(color: Color(0xFF2193b0), width: 2),
                                        ),
                                      ),
                                      obscureText: true,
                                    ),
                                    SizedBox(height: 20),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 46,
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF2193b0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                          elevation: 3,
                                          textStyle: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        icon: Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                                        label: Text(
                                          'Enter',
                                          style: TextStyle(
                                            color: Colors.white,
                                            letterSpacing: 1.1,
                                          ),
                                        ),
                                        onPressed: () {
                                          // TODO: Implement password reset logic
                                        },
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
