package com.monii.dto.response;

import java.time.LocalDateTime;

public class UserResponseDTO {
    private String email;
    private String fullName;
    private String avatarUrl;

    public UserResponseDTO(String fullName, String email, String avatarUrl) {
        this.fullName = fullName;
        this.email = email;
        this.avatarUrl = avatarUrl;
    }

    private LocalDateTime createdAt;
    private String language;
    private String currency;

    public String getEmail() {
        return email;
    }

    public String getFullName() {
        return fullName;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public String getLanguage() {
        return language;
    }

    public String getCurrency() {
        return currency;
    }
}