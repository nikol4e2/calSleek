package com.example.calsleek.model;

import lombok.Data;

@Data
public class Food {

    private String name;
    private int calories;
    private int carbs;
    private int protein;
    private int fats;

    public Food(String name, int calories, int carbs, int protein, int fats) {
        this.name = name;
        this.calories = calories;
        this.carbs = carbs;
        this.protein = protein;
        this.fats = fats;
    }
}
