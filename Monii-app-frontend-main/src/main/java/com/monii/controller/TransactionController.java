package com.monii.controller;

import com.monii.dto.request.TransactionRequestDTO;
import com.monii.dto.response.TransactionResponseDTO;
import com.monii.model.Transaction;
import com.monii.security.CustomUserDetails;
import com.monii.service.TransactionService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/transactions")
public class TransactionController {
    @Autowired
    private TransactionService transactionService;

    // Create Transaction
    @PostMapping
    public ResponseEntity<Transaction> createTransaction(
            @Valid @RequestBody TransactionRequestDTO transactionRequestDTO,
            @AuthenticationPrincipal CustomUserDetails userDetails
            ) {
        String userId = userDetails.getId();

        Transaction transaction = transactionService.saveTransaction(userId, transactionRequestDTO);

        return ResponseEntity.status(HttpStatus.CREATED).body(transaction);
    }

    // Get transactions by user id
    @GetMapping
    public ResponseEntity<List<TransactionResponseDTO>> getTransactionsByUserId(
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        String userId = userDetails.getId();

        List<TransactionResponseDTO> transactions = transactionService.getTransactionsByUserId(userId);

        if (transactions.isEmpty()) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(transactions);
    }

    // Get transaction by its id
    @GetMapping("/trans/{transactionId}")
    public ResponseEntity<TransactionResponseDTO> getTransactionById(
            @PathVariable Long transactionId,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        String userId = userDetails.getId();

        TransactionResponseDTO transaction = transactionService.getTransactionById(userId, transactionId);

        if (transactionId == null) {
            return ResponseEntity.noContent().build();
        }

        return ResponseEntity.ok(transaction);
    }

    // Get transactions by category
    @GetMapping("/{categoryId}")
    public ResponseEntity<List<TransactionResponseDTO>> getTransactionsByUserIdAndCategory(
            @PathVariable Long categoryId,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        String userId = userDetails.getId();

        List<TransactionResponseDTO> transactions = transactionService.getTransactionsByUserIdAndCategory(userId, categoryId);

        if (transactions.isEmpty()) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(transactions);
    }

    // Update transaction
    @PutMapping("/{transactionId}")
    public ResponseEntity<TransactionRequestDTO> updateTransaction(
            @PathVariable Long transactionId,
            @RequestBody TransactionRequestDTO transactionRequestDTO,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        String userId = userDetails.getId();

        TransactionRequestDTO updateTransaction = transactionService.updateTransaction(transactionId, userId, transactionRequestDTO);

        return ResponseEntity.ok(updateTransaction);
    }

    // Delete a transaction
    @DeleteMapping("/{transactionId}")
    public ResponseEntity<?> deleteTransaction(
            @PathVariable Long transactionId,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        String userId = userDetails.getId();
        transactionService.deleteTransaction(transactionId, userId);
        return ResponseEntity.noContent().build();
    }
}