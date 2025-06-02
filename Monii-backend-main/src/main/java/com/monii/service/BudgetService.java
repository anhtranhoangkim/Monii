package com.monii.service;

import com.monii.dto.request.BudgetRequestDTO;
import com.monii.dto.response.BudgetResponseDTO;
import com.monii.model.Budget;
import com.monii.model.Category;
import com.monii.model.User;
import com.monii.repository.BudgetRepository;
import com.monii.repository.CategoryRepository;
import com.monii.repository.UserRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class BudgetService {
    @Autowired
    private BudgetRepository budgetRepository;

    @Autowired
    private CategoryRepository categoryRepository;

    @Autowired
    private UserRepository userRepository;

    // Create a new budget
    public Budget saveBudget(String userId, BudgetRequestDTO budgetRequestDTO) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        Category category = categoryRepository.findById(budgetRequestDTO.getCategoryId())
                .orElseThrow(() -> new RuntimeException("Category not found"));

        if (!category.getUserId().equals(userId)) {
            throw new RuntimeException("You do not own this category.");
        }

        Budget budget = new Budget(
                budgetRequestDTO.getAmount(),
                userId,
                budgetRequestDTO.getCategoryId()
        );

        return budgetRepository.save(budget);
    }

    // Get budget by user id
    public List<BudgetResponseDTO> getBudgetsByUserId(String userId) {
        List<Budget> budgets = budgetRepository.findByUserId(userId);

        return budgets.stream()
                .map(budget -> new BudgetResponseDTO(
                        budget.getId(),
                        budget.getAmount(),
                        budget.getCategoryId()))
                .collect(Collectors.toList());
    }

    // Get budget by user id and category id
    public List<BudgetResponseDTO> getBudgetsByUserIdAndCategoryId(String userId, Long categoryId) {
        List<Budget> budgets = budgetRepository.findByUserIdAndCategoryId(userId, categoryId);

        return budgets.stream()
                .map(budget -> new BudgetResponseDTO(
                        budget.getId(),
                        budget.getAmount(),
                        budget.getCategoryId()))
                .collect(Collectors.toList());
    }

    // Update a budget
    @Transactional
    public BudgetRequestDTO updateBudget(Long budgetId, String userId, BudgetRequestDTO budgetRequestDTO) {
        Budget budget = budgetRepository.findById(budgetId)
                .orElseThrow(() -> new RuntimeException("Budget not found"));

        if (!budget.getUserId().equals(userId)) {
            throw new RuntimeException("Unauthorized: Not your budget");
        }

        budget.setAmount(budgetRequestDTO.getAmount());

        budgetRepository.save(budget);

        return new BudgetRequestDTO(
                budget.getAmount(),
                budget.getCategoryId()
        );
    }

    // Delete a budget
    @Transactional
    public void deleteBudget(Long budgetId, String userId) {
        Budget budget = budgetRepository.findById(budgetId)
                .orElseThrow(() -> new RuntimeException("Budget not found"));

        if (!budget.getUserId().equals(userId)) {
            throw new RuntimeException("Unauthorized: Not your own budget");
        }

        budgetRepository.delete(budget);
    }
}