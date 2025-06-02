package com.monii.service;

import com.monii.dto.request.LoginRequestDTO;
import com.monii.dto.request.RegisterRequestDTO;
import com.monii.model.User;
import com.monii.repository.UserRepository;
import com.monii.security.JwtUtil;
import com.monii.security.PasswordEncoderUtil;
import org.springframework.stereotype.Service;

@Service
public class AuthService {
    private final UserRepository userRepository;
    private final PasswordEncoderUtil passwordEncoderUtil;
    private final JwtUtil jwtUtil;

    public AuthService(UserRepository userRepository, PasswordEncoderUtil passwordEncoderUtil, JwtUtil jwtUtil) {
        this.userRepository = userRepository;
        this.passwordEncoderUtil = passwordEncoderUtil;
        this.jwtUtil = jwtUtil;
    }

    // Register service layer
    public void registerUser(RegisterRequestDTO request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new RuntimeException("Email is already taken");
        }

        User user = new User();

        user.setEmail(request.getEmail());
        user.setPassword(passwordEncoderUtil.encodePassword(request.getPassword()));
        user.setFullName(request.getFullName());
        user.setLanguage(request.getLanguage());
        user.setCurrency(request.getCurrency());

        userRepository.save(user);
    }

    // Login with Email service layer
    public String loginUser(LoginRequestDTO request) {
        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new RuntimeException("Invalid email"));

        if (!passwordEncoderUtil.matches(request.getPassword(), user.getPassword())) {
            throw new RuntimeException("Invalid credentials");
        }

        return jwtUtil.generateToken(user.getId());
    }
}