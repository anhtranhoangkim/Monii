package com.monii.dto.response;

import java.math.BigDecimal;

public class MonthlyTrendDTO {
    private int month; // 1 to 12
    private int year;
    private BigDecimal income = BigDecimal.ZERO;
    private BigDecimal expenditure = BigDecimal.ZERO;

    public MonthlyTrendDTO(int month, int year) {
        this.month = month;
        this.year = year;
    }

    public void addIncome(BigDecimal amount) {
        this.income = this.income.add(amount);
    }

    public void addExpenditure(BigDecimal amount) {
        this.expenditure = this.expenditure.add(amount);
    }

    // Getters and Setters

    public int getMonth() {
        return month;
    }

    public void setMonth(int month) {
        this.month = month;
    }

    public int getYear() {
        return year;
    }

    public void setYear(int year) {
        this.year = year;
    }

    public BigDecimal getIncome() {
        return income;
    }

    public void setIncome(BigDecimal income) {
        this.income = income;
    }

    public BigDecimal getExpenditure() {
        return expenditure;
    }

    public void setExpenditure(BigDecimal expenditure) {
        this.expenditure = expenditure;
    }
}

