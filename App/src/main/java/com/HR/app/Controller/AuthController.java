package com.HR.app.Controller;

import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.web.bind.annotation.*;

import com.HR.app.Security.JwtService;
import com.HR.app.Service.CustomUserDetailsService;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthenticationManager authenticationManager;
    private final CustomUserDetailsService userDetailsService;
    private final JwtService jwtService;
    private final PasswordResetService passwordResetService;

    public AuthController(AuthenticationManager authenticationManager,
                         CustomUserDetailsService userDetailsService,
                         JwtService jwtService,
                         PasswordResetService passwordResetService) {
        this.authenticationManager = authenticationManager;
        this.userDetailsService = userDetailsService;
        this.jwtService = jwtService;
        this.passwordResetService = passwordResetService;
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest request) {
        authenticationManager.authenticate(
            new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword())
        );
        var userDetails = userDetailsService.loadUserByUsername(request.getEmail());
        String jwt = jwtService.generateToken(userDetails);
        return ResponseEntity.ok(new JwtResponse(jwt));
    }

    @PostMapping("/forgot-password")
    public ResponseEntity<?> forgotPassword(@RequestBody ForgotPasswordRequest request) {
        passwordResetService.sendResetCode(request.getEmail());
        return ResponseEntity.ok("If the email exists, a reset link was sent.");
    }

    @PostMapping("/reset-password")
    public ResponseEntity<?> resetPassword(@RequestBody ResetPasswordRequest request) {
        boolean result = passwordResetService.resetPassword(request.getToken(), request.getNewPassword());
        if (result) return ResponseEntity.ok("Password reset successful.");
        else return ResponseEntity.badRequest().body("Invalid or expired token.");
    }
}

