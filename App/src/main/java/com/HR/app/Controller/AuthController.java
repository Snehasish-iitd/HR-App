package com.HR.app.Controller;

import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.web.bind.annotation.*;

import com.HR.app.DTO.ForgotPasswordRequest;
import com.HR.app.DTO.JwtResponse;
import com.HR.app.DTO.LoginRequest;
import com.HR.app.DTO.ResetPasswordRequest;
import com.HR.app.Security.JwtService;
import com.HR.app.Service.CustomUserDetailsService;
import com.HR.app.Service.PasswordResetService;

import lombok.AllArgsConstructor;
@AllArgsConstructor
@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthenticationManager authenticationManager;
    private final CustomUserDetailsService userDetailsService;
    private final JwtService jwtService;
    private final PasswordResetService passwordResetService;

    
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
        try {
            boolean result = passwordResetService.resetPassword(
                request.getEmail(),
                request.getCode(),
                request.getNewPassword(),
                request.getConfirmPassword()
            );
            if (result) {
                return ResponseEntity.ok("Password reset successful.");
            } else {
                return ResponseEntity.badRequest().body("Invalid or expired code.");
            }
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}

