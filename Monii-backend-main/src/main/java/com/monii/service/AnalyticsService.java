package com.monii.service;

import com.monii.dto.response.CategoryAnalyticsDTO;
import com.monii.dto.response.MonthlyTrendDTO;
import com.monii.model.Category;
import com.monii.model.Transaction;
import com.monii.repository.BudgetRepository;
import com.monii.repository.CategoryRepository;
import com.monii.repository.TransactionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.stream.Collectors;

@Service
public class AnalyticsService {

    @Autowired
    private TransactionRepository transactionRepository;

    @Autowired
    private CategoryRepository categoryRepository;

    @Autowired
    private BudgetRepository budgetRepository;

    public BigDecimal getTotalIncome(String userId) {
        return transactionRepository.sumAmountByUserAndCategoryType(userId, (byte) 1);
    }

    public BigDecimal getTotalExpenditure(String userId) {
        return transactionRepository.sumAmountByUserAndCategoryType(userId, (byte) 0);
    }

    public BigDecimal getTotalBalance(String userId) {
        BigDecimal income = getTotalIncome(userId);
        BigDecimal expenditure = getTotalExpenditure(userId);
        return income.subtract(expenditure);
    }

    public List<MonthlyTrendDTO> getMonthlyTrends(String userId) {
        List<Transaction> transactions = transactionRepository.findByUserId(userId);
        DateTimeFormatter inputFormatter = DateTimeFormatter.ISO_OFFSET_DATE_TIME;

        Map<String, MonthlyTrendDTO> trendMap = new TreeMap<>();

        for (Transaction tx : transactions) {
            try {
                LocalDateTime ldt = tx.getTransactionDate().toLocalDateTime();
                int month = ldt.getMonthValue();
                int year = ldt.getYear();

                String key = year + "-" + String.format("%02d", month);

                trendMap.putIfAbsent(key, new MonthlyTrendDTO(month, year));

                MonthlyTrendDTO trend = trendMap.get(key);
                if (tx.getCategory().getType() == 1) {
                    trend.addIncome(tx.getAmount());
                } else {
                    trend.addExpenditure(tx.getAmount());
                }

            } catch (DateTimeParseException e) {
                System.err.println("Failed to parse transactionDate: " + tx.getTransactionDate());
            }
        }

        return new ArrayList<>(trendMap.values());
    }

    public List<CategoryAnalyticsDTO> getCategoryAnalytics(String userId, Byte type) {
        List<Category> categories;

        if (type != null) {
            categories = categoryRepository.findByUserIdAndType(userId, type);
        } else {
            categories = categoryRepository.findByUserId(userId);
        }

        return categories.stream().map(category -> {
            Double total = transactionRepository.sumAmountByCategoryId(category.getId());
            Double budget = budgetRepository.findAmountByCategoryId(category.getId());

            return new CategoryAnalyticsDTO(
                    category.getId(),
                    category.getName(),
                    total != null ? total : 0.0,
                    budget
            );
        }).collect(Collectors.toList());
    }

}
