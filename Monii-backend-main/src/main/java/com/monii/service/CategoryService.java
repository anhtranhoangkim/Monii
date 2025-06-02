package com.monii.service;

import com.monii.dto.request.CategoryRequestDTO;
import com.monii.dto.response.CategoryResponseDTO;
import com.monii.model.Category;
import com.monii.model.User;
import com.monii.repository.BudgetRepository;
import com.monii.repository.CategoryRepository;
import com.monii.repository.TransactionRepository;
import com.monii.repository.UserRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class CategoryService {
    @Autowired
    private CategoryRepository categoryRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private TransactionRepository transactionRepository;

    @Autowired
    private BudgetRepository budgetRepository;

    // Create a new category
    public Category saveCategory(String userId, CategoryRequestDTO categoryRequestDTO) {
        User user = userRepository.findById(userId).orElseThrow(() -> new RuntimeException("User not found"));

        Category category = new Category(
                categoryRequestDTO.getName(),
                categoryRequestDTO.getType(),
//                categoryRequestDTO.getIcon(),
                categoryRequestDTO.getDescription(),
                userId // Use the userId from JWT
        );

        return categoryRepository.save(category);
    }

    // Get category by user id
    public List<CategoryResponseDTO> getCategoriesByUserId(String userId) {
        List<Category> categories = categoryRepository.findByUserId(userId);
        return categories.stream()
                .map(category -> new CategoryResponseDTO(
                        category.getId(),
                        category.getName(),
                        category.getType(),
//                        category.getIcon(),
                        category.getDescription()))
                .collect(Collectors.toList());
    }

    // Get category from Id
    public CategoryResponseDTO getCategoryById(String userId, Long categoryId) {
        Category category = categoryRepository.findByUserIdAndId(userId, categoryId);

        return new CategoryResponseDTO(
                category.getId(),
                category.getName(),
                category.getType(),
//          category.getIcon(),
                category.getDescription()
        );
    }

    public List<CategoryResponseDTO> getCategoriesByType(String userId, Byte type) {
        List<Category> categories = categoryRepository.findByUserIdAndType(userId, type);
        return categories.stream()
                .map(category -> new CategoryResponseDTO(
                        category.getId(),
                        category.getName(),
                        category.getType(),
//                        category.getIcon(),
                        category.getDescription()))
                .collect(Collectors.toList());
    }


    // update category
    @Transactional
    public CategoryRequestDTO updateCategory(Long categoryId, String userId, CategoryRequestDTO categoryRequestDTO) {
        Category category = categoryRepository.findById(categoryId)
                .orElseThrow(() -> new RuntimeException("Category not found"));

        if (!category.getUserId().equals(userId)) {
            throw new RuntimeException("Unauthorized: Not your category");
        }

        category.setName(categoryRequestDTO.getName());
        category.setType(categoryRequestDTO.getType());
//        category.setIcon(categoryRequestDTO.getIcon());
        category.setDescription(categoryRequestDTO.getDescription());
        category.setUpdatedAt(LocalDateTime.now());

         categoryRepository.save(category);

         return new CategoryRequestDTO(category.getName(), category.getType(), category.getDescription());
    }

    // delete category
    @Transactional
    public void deleteCategory(Long categoryId, String userId) {
        Category category = categoryRepository.findById(categoryId)
                .orElseThrow(() -> new RuntimeException("Category not found"));

        if (!category.getUserId().equals(userId)) {
            throw new RuntimeException("Unauthorized: Not your own category");
        }
        transactionRepository.deleteByCategoryId(categoryId);
        budgetRepository.deleteByCategoryId(categoryId);
        categoryRepository.delete(category);
    }



}
