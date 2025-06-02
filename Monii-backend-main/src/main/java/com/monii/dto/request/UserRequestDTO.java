package com.monii.dto.request;

public class UserRequestDTO {
    private String language;
    private String currency;

    public UserRequestDTO() {
    }

    public UserRequestDTO(String language, String currency) {
        this.language = language;
        this.currency = currency;
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
