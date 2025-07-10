package com.HR.app.Config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

import com.HR.app.Service.CustomUserDetailsService;

@Configuration
@EnableMethodSecurity 
public class SecurityConfig {

    private final CustomUserDetailsService userDetailsService;

    public SecurityConfig(CustomUserDetailsService userDetailsService) {
        this.userDetailsService = userDetailsService;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/login", "/forgot-password", "reset-password").permitAll()
                .requestMatchers("/reimbursements/approve").hasRole("MANAGER")
                .requestMatchers("/reimbursements/submit").hasRole("EMPLOYEE")
                .requestMatchers("/reimbursements/**").hasAnyRole("ADMIN", "HR", "MANAGER")
                .anyRequest().authenticated()
            )
            .formLogin(form -> form
                .loginPage("/login")
                .permitAll()
            )
            .rememberMe(rememberMe -> rememberMe
            .key("Nirjai-Technologies:81@24#39&56") // Change to a strong, secure value
            .tokenValiditySeconds(90 * 24 * 60 * 60) // 30 days in seconds
            .userDetailsService(userDetailsService)
        )
            .logout(logout -> logout.permitAll());
        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
