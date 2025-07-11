import 'package:flutter/material.dart';
import "forgotpassword.dart";

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool rememberMe = false;

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
            // Visible geometric pattern overlay
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
                      // Greeting Text with minimalistic icon
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Icon(
                              Icons.account_circle_outlined,
                              color: Color(0xFF1b2a49),
                              size: 38,
                            ),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome!',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1b2a49),
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                Text(
                                  'Login to continue',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 36),
                      // Gradient-bordered Card with internal pattern
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(2.5), // Border thickness
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
                            // Subtle internal pattern using gradient
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
                            children: [
                              // Email Field with minimalistic icon
                              TextField(
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
                              SizedBox(height: 20),
                              // Password Field with minimalistic icon
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(color: Colors.black87),
                                  prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF2193b0), size: 22),
                                  filled: true,
                                  fillColor: Color(0xFFe0eafc).withOpacity(0.18),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(color: Color(0xFF2193b0), width: 2),
                                  ),
                                ),
                                obscureText: true,
                              ),
                              SizedBox(height: 14),
                              // Remember Me & Forgot Password Row
                              Row(
                                    children: [
                                      Checkbox(
                                        value: rememberMe,
                                        activeColor: Color(0xFF2193b0),
                                        onChanged: (val) {
                                          setState(() {
                                            rememberMe = val ?? false;
                                          });
                                        },
                                      ),
                                      SizedBox(width: 4), // Reduces space between checkbox and text
                                      Text(
                                        'Remember me',
                                        style: TextStyle(color: Colors.black87),
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ForgotPasswordPage(),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            SizedBox(width: 4),
                                            Text(
                                              'Forgot password?',
                                              style: TextStyle(
                                                color: Color.fromARGB(255, 0, 0, 0),
                                                decoration: TextDecoration.underline,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                              SizedBox(height: 24),
                              // Sign In Button with minimal icon
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF2193b0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    elevation: 4,
                                    textStyle: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  icon: Icon(Icons.login, color: Colors.white, size: 22),
                                  label: Text(
                                    'SIGN IN',
                                    style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 1.3,
                                    ),
                                  ),
                                  onPressed: () {
                                    // TODO: Handle sign in
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
