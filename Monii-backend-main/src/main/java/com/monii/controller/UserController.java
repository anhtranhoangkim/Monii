package com.monii.controller;

import com.monii.dto.request.UserRequestDTO;
import com.monii.dto.response.UserResponseDTO;
import com.monii.security.CustomUserDetails;
import com.monii.security.JwtUtil;
import com.monii.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private JwtUtil jwtUtil;

    @GetMapping("/me")
    public ResponseEntity<UserResponseDTO> getUserInfo(
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        String userId = userDetails.getId();
        UserResponseDTO userInfo = userService.getUserInfo(userId);
        return ResponseEntity.ok(userInfo);
    }

    // 1. GET user's currency
    @GetMapping("/currency")
    public ResponseEntity<String> getCurrency(HttpServletRequest request) {
        String userId = jwtUtil.extractUserId(String.valueOf(request));
        String currency = userService.getUserCurrency(userId);
        return ResponseEntity.ok(currency);
    }

    // 2. PUT user's currency
    @PutMapping("/currency")
    public ResponseEntity<Void> updateCurrency(@RequestBody UserRequestDTO dto,
                                               HttpServletRequest request) {
        String userId = jwtUtil.extractUserId(String.valueOf(request));
        if (dto.getCurrency() == null || dto.getCurrency().isEmpty()) {
            return ResponseEntity.badRequest().build();
        }
        userService.updateCurrency(userId, dto.getCurrency());
        return ResponseEntity.noContent().build();
    }

    // 3. GET user's language
    @GetMapping("/language")
    public ResponseEntity<String> getLanguage(HttpServletRequest request) {
        String userId = jwtUtil.extractUserId(String.valueOf(request));
        String language = userService.getUserLanguage(userId);
        return ResponseEntity.ok(language);
    }

    // 4. PUT user's language
    @PutMapping("/language")
    public ResponseEntity<Void> updateLanguage(@RequestBody UserRequestDTO dto,
                                               HttpServletRequest request) {
        String userId = jwtUtil.extractUserId(String.valueOf(request));
        if (dto.getLanguage() == null || dto.getLanguage().isEmpty()) {
            return ResponseEntity.badRequest().build();
        }
        userService.updateLanguage(userId, dto.getLanguage());
        return ResponseEntity.noContent().build();
    }

    // GET /api/users/preferences
    @GetMapping("/preferences")
    public ResponseEntity<UserRequestDTO> getPreferences(HttpServletRequest request) {
        String userId = jwtUtil.extractUserId(String.valueOf(request));
        return ResponseEntity.ok(userService.getUserPreferences(userId));
    }

    // PUT /api/users/preferences
    @PutMapping("/preferences")
    public ResponseEntity<Void> updatePreferences(@RequestBody UserRequestDTO dto,
                                                  HttpServletRequest request) {
        String userId = jwtUtil.extractUserId(String.valueOf(request));
        userService.updateUserPreferences(userId, dto);
        return ResponseEntity.noContent().build();
    }
}
