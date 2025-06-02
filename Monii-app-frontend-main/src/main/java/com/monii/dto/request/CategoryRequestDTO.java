package com.monii.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public class CategoryRequestDTO {
    @NotBlank
    private String name;

    @NotNull
    private Byte type;

//    private String icon;
    private String description;

    public CategoryRequestDTO(String name, @NotNull Byte type, String description) {
        this.name = name;
        this.type = type;
//        this.icon = icon;
        this.description = description;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Byte getType() {
        return type;
    }

    public void setType(Byte type) {
        this.type = type;
    }

//    public String getIcon() {
//        return icon;
//    }
//
//    public void setIcon(String icon) {
//        this.icon = icon;
//    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
