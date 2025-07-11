package com.HR.app.Service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.HR.app.Model.PasswordResetToken;
import com.HR.app.Model.Users;
import com.HR.app.Repository.PasswordResetTokenRepository;
import com.HR.app.Repository.UserRepository;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.UUID;

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

    public void sendResetCode(String email) {
        Users user = userRepository.findByEmail(email)
            .orElseThrow(() -> new IllegalArgumentException("No user found with email: " + email));
        String token = UUID.randomUUID().toString();
        PasswordResetToken resetToken = new PasswordResetToken(token, user, LocalDateTime.now().plusMinutes(30));
        tokenRepository.save(resetToken);

        String resetUrl = "https://your-flutter-app/reset-password?token=" + token;
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(user.getEmail());
        message.setSubject("Password Reset Request");
        message.setText("Reset your password using this link (valid for 30 minutes): " + resetUrl);

        mailSender.send(message);
    }

    public boolean resetPassword(String token, String newPassword) {
        Optional<PasswordResetToken> resetTokenOpt = tokenRepository.findByToken(token);
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
