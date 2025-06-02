package com.monii.dto.request;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;

public class BudgetRequestDTO {
    @DecimalMin("0.01")
    private BigDecimal amount;

    @NotNull
    private Long categoryId;

    public BudgetRequestDTO(BigDecimal amount, @NotNull Long categoryId) {
        this.amount = amount;
        this.categoryId = categoryId;
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