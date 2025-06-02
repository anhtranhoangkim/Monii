package com.monii.service;

import com.monii.dto.request.TransactionRequestDTO;
import com.monii.dto.response.TransactionResponseDTO;
import com.monii.model.Category;
import com.monii.model.Transaction;
import com.monii.model.User;
import com.monii.repository.CategoryRepository;
import com.monii.repository.TransactionRepository;
import com.monii.repository.UserRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class TransactionService {
    @Autowired
    private  TransactionRepository transactionRepository;

    @Autowired
    private  CategoryRepository categoryRepository;

    @Autowired
    private UserRepository userRepository;

    // Create a new transaction
    public Transaction saveTransaction(String userId, TransactionRequestDTO transactionRequestDTO) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        Category category = categoryRepository.findById(transactionRequestDTO.getCategoryId())
                .orElseThrow(() -> new RuntimeException("Category not found"));

        if (!category.getUserId().equals(userId)) {
            throw new RuntimeException("You do not own this category.");
        }

        Transaction transaction = new Transaction(
                transactionRequestDTO.getName(),
                transactionRequestDTO.getAmount(),
                transactionRequestDTO.getNote(),
                transactionRequestDTO.getTransactionDate(),
                transactionRequestDTO.getPaymentMethod(),
                userId,
                transactionRequestDTO.getCategoryId()
        );

        return transactionRepository.save(transaction);
    }

    // Get transactions by user id
    public List<TransactionResponseDTO> getTransactionsByUserId(String userId) {
        List<Transaction> transactions = transactionRepository.findByUserId(userId);

        return transactions.stream()
                .map(transaction -> new TransactionResponseDTO(
                        transaction.getId(),
                        transaction.getName(),
                        transaction.getAmount(),
                        transaction.getNote(),
                        transaction.getTransactionDate(),
                        transaction.getPaymentMethod(),
                        transaction.getCategoryId(),
                        transaction.getCreatedAt(),
                        transaction.getUpdatedAt()))
                .collect(Collectors.toList());
    }

    // Get transaction by its id
    public TransactionResponseDTO getTransactionById(String userId, Long transactionId) {
        Transaction transaction = transactionRepository.findByUserIdAndId(userId, transactionId);

        return new TransactionResponseDTO(
                transaction.getId(),
                transaction.getName(),
                transaction.getAmount(),
                transaction.getNote(),
                transaction.getTransactionDate(),
                transaction.getPaymentMethod(),
                transaction.getCategoryId(),
                transaction.getCreatedAt(),
                transaction.getUpdatedAt()
        );
    }

    // Get transactions by category
    public List<TransactionResponseDTO> getTransactionsByUserIdAndCategory(String userId, Long categoryId) {
        List<Transaction> transactions = transactionRepository.findByUserIdAndCategoryId(userId, categoryId);

        return transactions.stream()
                .map(transaction -> new TransactionResponseDTO(
                        transaction.getId(),
                        transaction.getName(),
                        transaction.getAmount(),
                        transaction.getNote(),
                        transaction.getTransactionDate(),
                        transaction.getPaymentMethod(),
                        transaction.getCategoryId(),
                        transaction.getCreatedAt(),
                        transaction.getUpdatedAt()))
                .collect(Collectors.toList());
    }

    // Update transaction
    @Transactional
    public TransactionRequestDTO updateTransaction(Long transactionId, String userId, TransactionRequestDTO transactionRequestDTO) {
        Transaction transaction = transactionRepository.findById(transactionId)
                .orElseThrow(() -> new RuntimeException("Transaction not found"));

        if (!transaction.getUserId().equals(userId)) {
            throw new RuntimeException("Unauthorized: Not your transaction");
        }

        transaction.setName(transactionRequestDTO.getName());
        transaction.setAmount(transactionRequestDTO.getAmount());
        transaction.setNote(transactionRequestDTO.getNote());
        transaction.setTransactionDate(transactionRequestDTO.getTransactionDate());
        transaction.setPaymentMethod(transactionRequestDTO.getPaymentMethod());
        transaction.setCategoryId(transactionRequestDTO.getCategoryId());
        transaction.setUpdatedAt(Timestamp.valueOf(LocalDateTime.now()));

        transactionRepository.save(transaction);

        return new TransactionRequestDTO(
                transaction.getName(),
                transaction.getAmount(),
                transaction.getNote(),
                transaction.getTransactionDate(),
                transaction.getPaymentMethod(),
                transaction.getCategoryId()
        );
    }

    // Delete a transaction
    @Transactional
    public void deleteTransaction(Long transactionId, String userId) {
        Transaction transaction = transactionRepository.findById(transactionId)
                .orElseThrow(() -> new RuntimeException("Transaction not found"));

        if (!transaction.getUserId().equals(userId)) {
            throw new RuntimeException("Unauthorized: Not your own category");
        }

        transactionRepository.delete(transaction);
    }
}