package com.monii.service;

import com.monii.dto.request.UserRequestDTO;
import com.monii.dto.response.UserResponseDTO;
import com.monii.model.User;
import com.monii.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    public UserResponseDTO getUserInfo(String userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        return new UserResponseDTO(
                user.getFullName(),
                user.getEmail(),
                user.getAvatarUrl()
        );
    }


    public UserRequestDTO getUserPreferences(String userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        return new UserRequestDTO(user.getLanguage(), user.getCurrency());
    }

    public void updateUserPreferences(String userId, UserRequestDTO dto) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        if (dto.getCurrency() != null) {
            user.setCurrency(dto.getCurrency());
        }
        if (dto.getLanguage() != null) {
            user.setLanguage(dto.getLanguage());
        }

        userRepository.save(user);
    }

    public String getUserCurrency(String userId) {
        return getUserPreferences(userId).getCurrency();
    }

    public void updateCurrency(String userId, String currency) {
        UserRequestDTO dto = new UserRequestDTO();
        dto.setCurrency(currency);
        updateUserPreferences(userId, dto);
    }

    public String getUserLanguage(String userId) {
        return getUserPreferences(userId).getLanguage();
    }

    public void updateLanguage(String userId, String language) {
        UserRequestDTO dto = new UserRequestDTO();
        dto.setLanguage(language);
        updateUserPreferences(userId, dto);
    }
}
