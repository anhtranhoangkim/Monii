package com.monii.dto.response;

import java.math.BigDecimal;

public class BudgetResponseDTO {
    private Long id;
    private BigDecimal amount;
    private Long categoryId;

    public BudgetResponseDTO(Long id, BigDecimal amount, Long categoryId) {
        this.id = id;
        this.amount = amount;
        this.categoryId = categoryId;
    }

    // Getter & Setter
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public Long getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Long categoryId) {
        this.categoryId = categoryId;
    }
}
