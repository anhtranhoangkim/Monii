package com.monii.service;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseToken;
import com.monii.model.User;
import com.monii.repository.UserRepository;
import com.monii.security.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class GoogleAuthService {

    private final UserRepository userRepository;
    private final JwtUtil jwtUtil;

    @Autowired
    public GoogleAuthService(UserRepository userRepository, JwtUtil jwtUtil) {
        this.userRepository = userRepository;
        this.jwtUtil = jwtUtil;
    }

    public String verifyAndRegisterGoogleUser(String idTokenString) {
        try {
            // Verify Firebase token using FirebaseAuth instance
            FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(idTokenString);
            String userId = decodedToken.getUid();
            String email = decodedToken.getEmail();
            String name = decodedToken.getName();
            String pictureUrl = decodedToken.getPicture();

            System.out.println("✅ Firebase Token Verified! UID: " + userId + ", Email: " + email);

            // Check if the user already exists, if not, create a new user
            Optional<User> existingUser = userRepository.findByEmail(email);
            User user = existingUser.orElseGet(() -> {
                User newUser = new User();
                newUser.setGoogleId(userId);
                newUser.setEmail(email);
                newUser.setFullName(name);
                newUser.setAvatarUrl(pictureUrl);
                newUser.setLanguage("en");  // default language
                newUser.setCurrency("USD"); // default currency
                return userRepository.save(newUser);
            });

            // Generate JWT token for the user after successful verification and registration
            return jwtUtil.generateToken(user.getId());
        } catch (Exception e) {
            // Handle exception if token verification fails
            System.err.println("❌ Firebase Token verification failed: " + e.getMessage());
            throw new RuntimeException("Token verification failed: " + e.getMessage());
        }
    }
}
