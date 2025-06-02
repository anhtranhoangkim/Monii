package com.monii.controller;

import com.monii.dto.request.LoginRequestDTO;
import com.monii.dto.request.RegisterRequestDTO;
import com.monii.service.AuthService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/auth")
public class AuthController {
    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    // Register
    @PostMapping("register")
    public ResponseEntity<String> registerUser(@RequestBody RegisterRequestDTO request) {
        authService.registerUser(request);
        return ResponseEntity.ok("User registered successfully!");
    }

    // Login with Google
//    @PostMapping("/google-login")
//    public ResponseEntity<?> googleLogin(@RequestBody Map<String, String> request) {
//        String receivedToken = request.get("token");
//
//        // Log received token
//        System.out.println("Received Token: " + receivedToken);
//
//        try {
//            User user = googleAuthService.verifyAndRegisterGoogleUser(receivedToken);
//            return ResponseEntity.ok(user);
//        } catch (Exception e) {
//            System.err.println("Token verification failed: " + e.getMessage());
//            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid Token: " + e.getMessage());
//        }
//    }

    // Login with Email
    @PostMapping("/login")
    public ResponseEntity<String> loginUser(@RequestBody LoginRequestDTO request) {
        String token = authService.loginUser(request);
//        System.out.println("Token in controller: " + token);
        return ResponseEntity.ok(token);
    }

    // Logout
//    @PostMapping("/logout")

}