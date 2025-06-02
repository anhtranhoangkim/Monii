package com.monii.dto.response;

import com.monii.model.PaymentMethod;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDateTime;

public class TransactionResponseDTO {
    private Long id;
    private String name;
    private BigDecimal amount;
    private String note;
    private Timestamp transactionDate;
    private PaymentMethod paymentMethod;
    private Long categoryId;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public TransactionResponseDTO(Long id, String name, BigDecimal amount, String note, Timestamp transactionDate, PaymentMethod paymentMethod, Long categoryId, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.id = id;
        this.name = name;
        this.amount = amount;
        this.note = note;
        this.transactionDate = transactionDate;
        this.paymentMethod = paymentMethod;
        this.categoryId = categoryId;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
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

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}