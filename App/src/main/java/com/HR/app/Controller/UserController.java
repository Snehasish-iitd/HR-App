package com.HR.app.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.HR.app.Enums.RoleEnum;
import com.HR.app.Model.Users;
import com.HR.app.Service.UserService;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/admin/users/employee")
public class UserController {

    @Autowired
    private UserService userService;

    @GetMapping
    public List<Users> getAllUsers() {
        return userService.getAllUsers();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Users> getUserById(@PathVariable UUID id) {
        return userService.getUserById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public Users createUser(@RequestBody Users user) {
        return userService.createUser(user);
    }

    @PutMapping("/{id}")
    public Users updateUser(@PathVariable UUID id, @RequestBody Users user) {
        return userService.updateUser(id, user);
    }

    @PutMapping("/{id}/role")
    public Users updateUserRole(@PathVariable UUID id, @RequestBody RoleEnum role) {
        return userService.updateUserRole(id, role);
    }

    @DeleteMapping("/{id}")
    public void deleteUser(@PathVariable UUID id) {
        userService.deleteUser(id);
    }
}

