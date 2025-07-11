package com.HR.app.Service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.HR.app.Model.PasswordResetToken;
import com.HR.app.Model.Users;
import com.HR.app.Repository.PasswordResetTokenRepository;
import com.HR.app.Repository.UserRepository;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.Random;

@Service
public class PasswordResetService {

    @Autowired
    private UserRepository userRepository;
    @Autowired
    private PasswordResetTokenRepository tokenRepository;
    @Autowired
    private JavaMailSender mailSender;
    @Autowired
    private PasswordEncoder passwordEncoder;

    // Generate a random 4-digit code
    private String generateOtpCode() {
        Random random = new Random();
        int otp = 1000 + random.nextInt(9000);
        return String.valueOf(otp);
    }

    public void sendResetCode(String email) {
        Users user = userRepository.findByEmail(email)
            .orElseThrow(() -> new IllegalArgumentException("No user found with email: " + email));
        String code = generateOtpCode();
        PasswordResetToken resetToken = new PasswordResetToken(code, user, LocalDateTime.now().plusMinutes(30));
        tokenRepository.save(resetToken);

        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(user.getEmail());
        message.setSubject("Password Reset Code");
        message.setText("Your password reset code is: " + code + "\nThis code is valid for 30 minutes.");

        mailSender.send(message);
    }

    public boolean resetPassword(String email, String code, String newPassword, String confirmPassword) {
        if (!newPassword.equals(confirmPassword)) {
            throw new IllegalArgumentException("Passwords do not match");
        }
        Optional<PasswordResetToken> resetTokenOpt = tokenRepository.findByUserEmailAndCode(email, code);
        if (resetTokenOpt.isPresent()) {
            PasswordResetToken resetToken = resetTokenOpt.get();
            if (resetToken.getExpiry().isAfter(LocalDateTime.now())) {
                Users user = resetToken.getUser();
                user.setPassword(passwordEncoder.encode(newPassword));
                userRepository.save(user);
                tokenRepository.delete(resetToken);
                return true;
            } else {
                tokenRepository.delete(resetToken);
            }
        }
        return false;
    }
}
