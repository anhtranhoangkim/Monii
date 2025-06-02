package com.monii.controller;

import com.monii.dto.request.CategoryRequestDTO;
import com.monii.dto.response.CategoryResponseDTO;
import com.monii.model.Category;
import com.monii.security.CustomUserDetails;
import com.monii.service.CategoryService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/categories")
public class CategoryController {
    @Autowired
    private CategoryService  categoryService;

    // Create Category
    @PostMapping
    public ResponseEntity<Category> createCategory(
            @Valid @RequestBody CategoryRequestDTO categoryRequestDTO,
            @AuthenticationPrincipal CustomUserDetails userDetails
            ) {
        String userId = userDetails.getId();
        Category category = categoryService.saveCategory(userId, categoryRequestDTO);

        return ResponseEntity.status(HttpStatus.CREATED).body(category);
    }

    // Get all categories by user id
    @GetMapping
    public ResponseEntity<List<CategoryResponseDTO>> getCategoriesForUser(
            @RequestParam(required = false) Byte type,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        String userId = userDetails.getId();
        List<CategoryResponseDTO> categories;

        if (type != null) {
            categories = categoryService.getCategoriesByType(userId, type);
        } else {
            categories = categoryService.getCategoriesByUserId(userId);
        }

        if (categories.isEmpty()) {
            return ResponseEntity.noContent().build();
        }

        return ResponseEntity.ok(categories);
    }

    // Get a category by its id
    @GetMapping("/{categoryId}")
    public ResponseEntity<CategoryResponseDTO> getCategoryById(
            @PathVariable Long categoryId,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        String userId = userDetails.getId();

        CategoryResponseDTO category = categoryService.getCategoryById(userId, categoryId);

        if (categoryId == null) {
            return ResponseEntity.noContent().build();
        }

        return ResponseEntity.ok(category);
    }


    // Update a category
    @PutMapping("/{categoryId}")
    public ResponseEntity<CategoryRequestDTO> updateCategory(
            @PathVariable Long categoryId,
            @RequestBody CategoryRequestDTO categoryRequestDTO,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        String userId = userDetails.getId();

        CategoryRequestDTO updateCategory = categoryService.updateCategory(categoryId, userId, categoryRequestDTO);

        return ResponseEntity.ok(updateCategory);
    }

    // Delete a category
    @DeleteMapping("/{categoryId}")
    public ResponseEntity<?> deleteCategory(
            @PathVariable Long categoryId,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        String userId = userDetails.getId();
        categoryService.deleteCategory(categoryId, userId);
        return ResponseEntity.noContent().build(); // 204
    }
}
