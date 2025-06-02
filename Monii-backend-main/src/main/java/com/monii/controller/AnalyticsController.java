package com.monii.controller;

import com.monii.dto.response.CategoryAnalyticsDTO;
import com.monii.dto.response.MonthlyTrendDTO;
import com.monii.security.CustomUserDetails;
import com.monii.service.AnalyticsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;
import java.util.List;

@RestController
@RequestMapping("/api/analytics")
public class AnalyticsController {

    @Autowired
    private AnalyticsService analyticsService;

    @GetMapping("/total-income")
    public ResponseEntity<BigDecimal> getTotalIncome(@AuthenticationPrincipal CustomUserDetails userDetails) {
        String userId = userDetails.getId();
        return ResponseEntity.ok(analyticsService.getTotalIncome(userId));
    }

    @GetMapping("/total-expenditure")
    public ResponseEntity<BigDecimal> getTotalExpenditure(@AuthenticationPrincipal CustomUserDetails userDetails) {
        String userId = userDetails.getId();
        return ResponseEntity.ok(analyticsService.getTotalExpenditure(userId));
    }

    @GetMapping("/total-balance")
    public ResponseEntity<BigDecimal> getTotalBalance(@AuthenticationPrincipal CustomUserDetails userDetails) {
        String userId = userDetails.getId();
        return ResponseEntity.ok(analyticsService.getTotalBalance(userId));
    }

    @GetMapping("/month-trends")
    public ResponseEntity<List<MonthlyTrendDTO>> getMonthlyTrends(
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        String userId = userDetails.getId();
        List<MonthlyTrendDTO> trends = analyticsService.getMonthlyTrends(userId);
        return ResponseEntity.ok(trends);
    }

    @GetMapping("/category-summary")
    public ResponseEntity<List<CategoryAnalyticsDTO>> getCategoryAnalytics(
            @RequestParam(required = false) Byte type,
            @AuthenticationPrincipal CustomUserDetails userDetails) {

        String userId = userDetails.getId();
        List<CategoryAnalyticsDTO> analytics = analyticsService.getCategoryAnalytics(userId, type);
        return ResponseEntity.ok(analytics);
    }
}

