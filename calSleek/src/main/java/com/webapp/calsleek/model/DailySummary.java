package com.webapp.calsleek.model;


import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Entity
@NoArgsConstructor
public class DailySummary {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    private LocalDateTime date;
    private int totalCalories;
    private int totalCarbs;
    private int totalProteins;
    private int totalFats;
    private int totalcaloriesBurned;


    public DailySummary(LocalDateTime date) {
        this.date = date;
        this.totalCalories = 0;
        this.totalCarbs = 0;
        this.totalProteins = 0;
        this.totalFats = 0;
        this.totalcaloriesBurned = 0;
    }

    public DailySummary(LocalDateTime date, int totalCalories, int totalCarbs, int totalFats, int totalProteins, int totalcaloriesBurned) {
        this.date = date;
        this.totalCalories = totalCalories;
        this.totalCarbs = totalCarbs;
        this.totalFats = totalFats;
        this.totalProteins = totalProteins;
        this.totalcaloriesBurned = totalcaloriesBurned;
    }
}
