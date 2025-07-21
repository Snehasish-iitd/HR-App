package com.HR.app.Config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import com.HR.app.Security.JwtAuthFilter;

@Configuration
@EnableMethodSecurity
public class SecurityConfig {

    private final JwtAuthFilter jwtAuthFilter;

    public SecurityConfig(JwtAuthFilter jwtAuthFilter) {
        this.jwtAuthFilter = jwtAuthFilter;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            // Enable CORS to apply your WebMvcConfigurer settings
            .cors()
            .and()
            // Disable CSRF – appropriate for stateless JWT APIs
            .csrf(csrf -> csrf.disable())

            // Stateless session management for REST APIs
            .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))

            // Configure route authorization rules
            .authorizeHttpRequests(auth -> auth
                // Permit all to /api/auth/**
                .requestMatchers("/api/auth/**").permitAll()

                .requestMatchers("/company-drive/**").permitAll()

                // Permit preflight CORS OPTIONS requests for all paths
                .requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()

                // Admin role required for /api/admin/**
                .requestMatchers("/api/admin/**").hasRole("ADMIN")

                // Manager role required to approve reimbursements
                
                // Employee role required to submit reimbursements
                .requestMatchers("/api/reimbursements/submit").hasAnyRole("EMPLOYEE","ADMIN","HR","MANAGER")

                .requestMatchers("/api/reimbursements/history").hasAnyRole("EMPLOYEE","ADMIN","HR","MANAGER")

                // Admin, HR or Manager roles for other reimbursements endpoints
                .requestMatchers("/api/reimbursements/**").hasAnyRole("ADMIN", "HR", "MANAGER")

                // Any other request requires authentication
                .anyRequest().authenticated()
            )

            // Add your JWT authentication filter before the username/password filter
            .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    // BCrypt password encoder bean
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    // Expose AuthenticationManager bean
    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authenticationConfiguration) throws Exception {
        return authenticationConfiguration.getAuthenticationManager();
    }
}
