package com.monii.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.Date;

@Component
public class JwtUtil {
    @Value("${jwt.secret}")
    private String SECRET_KEY;

    private final long EXPIRATION_TIME = 1000 * 60 * 60 * 10;


    // Method to generate the JWT token using the private key
    public String generateToken(String userId) {
        Claims claims = Jwts.claims().setSubject(userId);  // Set the user email as subject
        claims.put("userId", userId);  // Add userId to the token claims

        Date now = new Date();
        Date validity = new Date(now.getTime() + EXPIRATION_TIME);  // Set token expiration time

        return Jwts.builder()
                .setClaims(claims)  // Add the claims to the token
                .setIssuedAt(now)   // Set issue time
                .setExpiration(validity)  // Set expiration time
                .signWith(SignatureAlgorithm.HS256, SECRET_KEY)  // Sign the token with the secret key
                .compact();  // Build the token
    }

    // Validate the token
    public boolean validateToken(String token) {
        try {
            Jwts.parser()
                    .setSigningKey(SECRET_KEY)
                    .parseClaimsJws(token);  // Parse the token and verify its signature
            return true;  // Valid token
        } catch (Exception e) {
            return false;  // Invalid token
        }
    }

    // Extract userId from the token
    public String extractUserId(String token) {
        Claims claims = Jwts.parser()
                .setSigningKey(SECRET_KEY)
                .parseClaimsJws(token)
                .getBody();
        return claims.get("userId", String.class);  // Extract the userId from claims
    }

    // Optional: Extract the username (email in this case) from the token
    public String extractUsername(String token) {
        Claims claims = Jwts.parser()
                .setSigningKey(SECRET_KEY)
                .parseClaimsJws(token)
                .getBody();
        return claims.getSubject();  // Get the subject (email)
    }
}