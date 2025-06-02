package com.monii.controller;

import com.monii.dto.request.BudgetRequestDTO;
import com.monii.dto.response.BudgetResponseDTO;
import com.monii.model.Budget;
import com.monii.security.CustomUserDetails;
import com.monii.service.BudgetService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/budgets")
public class BudgetController {
    @Autowired
    private BudgetService budgetService;

    // Create a budget
    @PostMapping
    public ResponseEntity<Budget> createBudget(
            @Valid @RequestBody BudgetRequestDTO budgetRequestDTO,
            @AuthenticationPrincipal CustomUserDetails userDetails
            ) {
        String userId = userDetails.getId();
        Budget budget = budgetService.saveBudget(userId, budgetRequestDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(budget);
    }

    // Get budgets by user id
    @GetMapping
    public ResponseEntity<List<BudgetResponseDTO>> getBudgetsByUserId(
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        String userId = userDetails.getId();
        List<BudgetResponseDTO> budgets = budgetService.getBudgetsByUserId(userId);

        if (budgets.isEmpty()) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(budgets);
    }

    // Get budgets by user id and category id
    @GetMapping("/{categoryId}")
    public ResponseEntity<List<BudgetResponseDTO>> getBudgetsByUserIdAndCategoryId(
            @PathVariable Long categoryId,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        String userId = userDetails.getId();
        List<BudgetResponseDTO> budgets = budgetService.getBudgetsByUserIdAndCategoryId(userId, categoryId);

        if (budgets.isEmpty()) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(budgets);
    }

    // Update a budget
    @PutMapping("/{budgetId}")
    public ResponseEntity<BudgetRequestDTO> updateBudget(
            @PathVariable Long budgetId,
            @RequestBody BudgetRequestDTO budgetRequestDTO,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        String userId = userDetails.getId();

        BudgetRequestDTO updateBudget = budgetService.updateBudget(budgetId, userId, budgetRequestDTO);

        return ResponseEntity.ok(updateBudget);
    }

    // Delete a budget
    @DeleteMapping("/{budgetId}")
    public ResponseEntity<?> deleteBudget(
            @PathVariable Long budgetId,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        String userId = userDetails.getId();
        budgetService.deleteBudget(budgetId, userId);
        return ResponseEntity.noContent().build();
    }
}