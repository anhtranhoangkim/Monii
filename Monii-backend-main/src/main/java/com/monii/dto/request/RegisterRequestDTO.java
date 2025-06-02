package com.monii.dto.request;

public class RegisterRequestDTO {
    private String email;
    private String password;

    private String fullName;
    private String language;
    private String currency;

    public RegisterRequestDTO() {
    }

    public RegisterRequestDTO(String email, String password, String fullName, String language, String currency) {
        this.email = email;
        this.password = password;
        this.fullName = fullName;
        this.language = language;
        this.currency = currency;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }
}