package com.HR.app.Service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.HR.app.Enums.RoleEnum;
import com.HR.app.Model.Users;
import com.HR.app.Repository.UserRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public List<Users> getAllUsers() {
        return userRepository.findAll();
    }

    public Optional<Users> getUserById(UUID id) {
        return userRepository.findById(id);
    }

    /**
     * Creates a user, ensuring the password is always securely hashed.
     * You should consider refactoring to accept a DTO instead of Users directly.
     */
    public Users createUser(Users user) {
        // Hash the password before saving
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        return userRepository.save(user);
    }

    /**
     * Updates user fields. If updating password, always hash it!
     * Here, you can add logic to only update password if it's changed.
     */
    public Users updateUser(UUID id, Users updatedUser) {
        return userRepository.findById(id)
                .map(user -> {
                    user.setName(updatedUser.getName());
                    user.setEmail(updatedUser.getEmail());
                    user.setRole(updatedUser.getRole());
                    user.setEid(updatedUser.getEid());
                    user.setDepartment(updatedUser.getDepartment());
                    // If a new password is provided, hash and save it
                    if (updatedUser.getPassword() != null && !updatedUser.getPassword().isBlank()) {
                        user.setPassword(passwordEncoder.encode(updatedUser.getPassword()));
                    }
                    user.setManagerId(updatedUser.getManagerId());
                    return userRepository.save(user);
                })
                .orElseThrow(() -> new RuntimeException("User not found"));
    }

    public void deleteUser(UUID id) {
        userRepository.deleteById(id);
    }

    public Users updateUserRole(UUID id, RoleEnum role) {
        return userRepository.findById(id)
                .map(user -> {
                    user.setRole(role);
                    return userRepository.save(user);
                })
                .orElseThrow(() -> new RuntimeException("User not found"));
    }
}
