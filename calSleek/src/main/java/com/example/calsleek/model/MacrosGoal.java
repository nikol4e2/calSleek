package com.example.calsleek.model;


import lombok.Data;

import java.time.LocalDate;
import java.util.Date;

@Data
public class MacrosGoal {
    private Long id;
    private LocalDate date;
    private int calories;
    private int protein;
    private int carbs;
    private int fats;

    public MacrosGoal(LocalDate date, int calories, int protein, int carbs, int fats) {
        this.date = date;
        this.calories = calories;
        this.protein = protein;
        this.carbs = carbs;
        this.fats = fats;
    }
}
