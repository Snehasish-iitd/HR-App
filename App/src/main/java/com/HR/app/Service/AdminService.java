package com.HR.app.Service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.HR.app.Model.Users;

import com.HR.app.Repository.UserRepository;
import com.HR.app.DTO.CreateUserRequest;

@Service
public class AdminService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Transactional
    public Users createUser(CreateUserRequest request) {
        // Validate input
        if (request.getEmail() == null || request.getEmail().isBlank()) {
            throw new IllegalArgumentException("Email must not be empty.");
        }
        if (request.getPassword() == null || request.getPassword().length() < 8) {
            throw new IllegalArgumentException("Password must be at least 8 characters.");
        }
        if (request.getRole() == null) {
            throw new IllegalArgumentException("Role must be provided.");
        }

        // Check for existing email
        if (userRepository.findByEmail(request.getEmail()).isPresent()) {
            throw new IllegalArgumentException("A user with this email already exists.");
        }

        // Hash password
        String hashedPassword = passwordEncoder.encode(request.getPassword());

        // Assign role and save user
        Users user = new Users();
        user.setEmail(request.getEmail());
        user.setPassword(hashedPassword);
        user.setRole(request.getRole());

        return userRepository.save(user);
    }
}

