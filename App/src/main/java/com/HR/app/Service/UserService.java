package com.HR.app.Service;

import org.springframework.beans.factory.annotation.Autowired;

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

    public List<Users> getAllUsers() {
        return userRepository.findAll();
    }

    public Optional<Users> getUserById(UUID id) {
        return userRepository.findById(id);
    }

    public Users createUser(Users user) {
        // Add business rules as needed
        return userRepository.save(user);
    }

    public Users updateUser(UUID id, Users updatedUser) {
        return userRepository.findById(id)
                .map(user -> {
                    user.setName(updatedUser.getName());
                    user.setEmail(updatedUser.getEmail());
                    user.setRole(updatedUser.getRole());
                    user.setEID(updatedUser.getEID());
                    user.setDepartment(updatedUser.getDepartment());
                    return userRepository.save(user);
                })
                .orElseThrow(() -> new RuntimeException("User not found"));
    }

    public void deleteUser(UUID id) {
        userRepository.deleteById(id);
    }

    // Optional: Update only user role
    public Users updateUserRole(UUID id, RoleEnum role) {
        return userRepository.findById(id)
                .map(user -> {
                    user.setRole(role);
                    return userRepository.save(user);
                })
                .orElseThrow(() -> new RuntimeException("User not found"));
    }
}

