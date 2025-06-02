package com.monii.dto.response;

public class CategoryResponseDTO {
    private Long id;
    private String name;
    private Byte type;
//    private String icon;
    private String description;

    public CategoryResponseDTO(Long id, String name, Byte type, String description) {
        this.id = id;
        this.name = name;
        this.type = type;
//        this.icon = icon;
        this.description = description;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
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
