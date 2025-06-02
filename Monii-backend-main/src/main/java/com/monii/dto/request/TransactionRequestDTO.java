package com.monii.dto.request;

import com.monii.model.PaymentMethod;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class TransactionRequestDTO {
    @NotBlank
    private String name;

    @DecimalMin("0.01")
    private BigDecimal amount;

    private String note;

    @NotNull
    private Timestamp transactionDate;

    @NotNull
    private PaymentMethod paymentMethod;

    @NotNull
    private Long categoryId;

    public TransactionRequestDTO(String name, BigDecimal amount, String note, @NotNull Timestamp transactionDate, @NotNull PaymentMethod paymentMethod, Long categoryId) {
        this.name = name;
        this.amount = amount;
        this.note = note;
        this.transactionDate = transactionDate;
        this.paymentMethod = paymentMethod;
        this.categoryId = categoryId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Timestamp getTransactionDate() {
        return transactionDate;
    }

    public void setTransactionDate(Timestamp transactionDate) {
        this.transactionDate = transactionDate;
    }

    public PaymentMethod getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(PaymentMethod paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public Long getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Long categoryId) {
        this.categoryId = categoryId;
    }
}