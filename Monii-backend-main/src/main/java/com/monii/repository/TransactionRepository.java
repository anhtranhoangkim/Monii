package com.monii.repository;

import com.monii.model.Transaction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.math.BigDecimal;
import java.util.List;

public interface TransactionRepository extends JpaRepository<Transaction, Long> {
    List<Transaction> findByUserId(String userId);

    List<Transaction> findByUserIdAndCategoryId(String userId, Long categoryId);

    @Query("SELECT COALESCE(SUM(t.amount), 0) FROM Transaction t " +
            "JOIN Category c ON t.categoryId = c.id " +
            "WHERE t.userId = :userId AND c.type = :type")
    BigDecimal sumAmountByUserAndCategoryType(@Param("userId") String userId, @Param("type") byte type);

    @Query("SELECT SUM(t.amount) FROM Transaction t WHERE t.category.id = :categoryId")
    Double sumAmountByCategoryId(@Param("categoryId") Long categoryId);

    void deleteByCategoryId(Long categoryId);

    Transaction findByUserIdAndId(String userId, Long transactionId);
}