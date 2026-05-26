package com.webapp.calsleek.model;


import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@Entity
@NoArgsConstructor
public class DailySummary {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private LocalDate date;
    private int totalCalories;
    private int totalCarbs;
    private int totalProteins;
    private int totalFats;
    private int totalCaloriesBurned;


    public DailySummary(LocalDate date) {
        this.date = date;
        this.totalCalories = 0;
        this.totalCarbs = 0;
        this.totalProteins = 0;
        this.totalFats = 0;
        this.totalCaloriesBurned = 0;
    }

    public DailySummary(LocalDate date, int totalCalories, int totalCarbs, int totalFats, int totalProteins, int totalCaloriesBurned) {
        this.date = date;
        this.totalCalories = totalCalories;
        this.totalCarbs = totalCarbs;
        this.totalFats = totalFats;
        this.totalProteins = totalProteins;
        this.totalCaloriesBurned = totalCaloriesBurned;
    }
}
