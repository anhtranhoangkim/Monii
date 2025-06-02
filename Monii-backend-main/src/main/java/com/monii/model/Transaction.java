package com.monii.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.DecimalMin;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDateTime;

@Entity
@Table(name = "transactions")
public class Transaction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 255)
    private String name;

    @Column(nullable = false)
    @DecimalMin("0.01")
    private BigDecimal amount;

    @Column(columnDefinition = "TEXT")
    private String note;

    @Column(name = "transaction_date", nullable = false)
    private Timestamp transactionDate;

    @Enumerated(EnumType.STRING)
    @Column(name = "payment_method", nullable = false)
    private PaymentMethod paymentMethod = PaymentMethod.CASH;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;


    @Column(name = "user_id", nullable = false, columnDefinition = "CHAR(36)")
    private String userId;

    @ManyToOne
    @JoinColumn(name = "user_id", referencedColumnName = "id", insertable = false, updatable = false)
    private User user;

    @Column(name = "category_id", nullable = false)
    private Long categoryId;

    @ManyToOne
    @JoinColumn(name = "category_id", referencedColumnName = "id", insertable = false, updatable = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    private Category category;

    @PrePersist
    protected void onCreate() {
        if (transactionDate == null) {
            transactionDate = new Timestamp(System.currentTimeMillis()); // Set current timestamp
        }
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    // Constructors
    public Transaction() {}

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Transaction(String name, BigDecimal amount, String note, Timestamp transactionDate,
                       PaymentMethod paymentMethod,
                       String userId, Long categoryId) {
        this.name = name;
        this.amount = amount;
        this.note = note;
        this.transactionDate = transactionDate;
        this.paymentMethod = paymentMethod;
        this.userId = userId;
        this.categoryId = categoryId;
        this.createdAt = new Timestamp(System.currentTimeMillis()).toLocalDateTime();
        this.updatedAt = new Timestamp(System.currentTimeMillis()).toLocalDateTime();
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public Timestamp getTransactionDate() { return transactionDate; }
    public void setTransactionDate(Timestamp transactionDate) { this.transactionDate = transactionDate; }

    public PaymentMethod getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(PaymentMethod paymentMethod) { this.paymentMethod = paymentMethod; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt.toLocalDateTime(); }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt.toLocalDateTime(); }

    public String getUserId() { return userId; }

    public Long getCategoryId() { return categoryId; }
    public void setCategoryId(Long categoryId) { this.categoryId = categoryId; }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }
}
