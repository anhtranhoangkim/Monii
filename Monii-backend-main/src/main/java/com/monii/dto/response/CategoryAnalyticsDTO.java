package com.monii.dto.response;

public class CategoryAnalyticsDTO {
    private Long categoryId;
    private String categoryName;
    private Double total;
    private Double budget;

    public CategoryAnalyticsDTO(Long categoryId, String categoryName, Double total, Double budget) {
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.total = total;
        this.budget = budget;
    }

    // Getters and setters

    public Long getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Long categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public Double getTotal() {
        return total;
    }

    public void setTotal(Double total) {
        this.total = total;
    }

    public Double getBudget() {
        return budget;
    }

    public void setBudget(Double budget) {
        this.budget = budget;
    }
}

