package com.monii.repository;

import com.monii.model.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface CategoryRepository extends JpaRepository<Category, Long> {
    List<Category> findByUserId(String userId);

    @Query("SELECT c FROM Category c WHERE c.userId = :userId AND c.type = :type")
    List<Category> findByUserIdAndType(@Param("userId") String userId, @Param("type") Byte type);

    Category findByUserIdAndId(String userId, Long categoryId);
}