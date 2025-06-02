package com.monii.controller;

import com.monii.dto.request.LoginRequestDTO;
import com.monii.dto.request.RegisterRequestDTO;
import com.monii.service.AuthService;
import com.monii.service.GoogleAuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/auth")
public class AuthController {
    @Autowired
    private  AuthService authService;

    @Autowired
    private GoogleAuthService googleAuthService;


    // Register
    @PostMapping("register")
    public ResponseEntity<String> registerUser(@RequestBody RegisterRequestDTO request) {
        authService.registerUser(request);
        return ResponseEntity.ok("User registered successfully!");
    }

    // Login with Google
    @PostMapping("/google-login")
    public ResponseEntity<String> googleLogin(@RequestBody Map<String, Object> body) {
        System.out.println("🪵 Raw Request Body: " + body);

        String idToken = (String) body.get("idToken");
        if (idToken == null || idToken.isEmpty()) {
            return ResponseEntity.badRequest().body("Invalid Token: Token must not be null or empty");
        }

        System.out.println("✅ Received ID Token: " + idToken);

        try {
            String token = googleAuthService.verifyAndRegisterGoogleUser(idToken);
            System.out.println("Token in controller: " + token);
            return ResponseEntity.ok(token);
        } catch (Exception e) {
            System.err.println("Token verification failed: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid Token: " + e.getMessage());
        }
    }

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