package com.monii.repository;

import com.monii.model.Budget;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface BudgetRepository extends JpaRepository<Budget, Long> {
    List<Budget> findByUserId(String userId);

    List<Budget> findByUserIdAndCategoryId(String userId, Long categoryId);

    @Query("SELECT b.amount FROM Budget b WHERE b.category.id = :categoryId")
    Double findAmountByCategoryId(@Param("categoryId") Long categoryId);

    void deleteByCategoryId(Long categoryId);
}