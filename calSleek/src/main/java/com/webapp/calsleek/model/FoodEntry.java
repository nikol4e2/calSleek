package com.webapp.calsleek.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.webapp.calsleek.model.enums.TimeCategory;
import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@Entity
public class FoodEntry {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(EnumType.STRING)
    private TimeCategory category;

    @ManyToOne()
    @JoinColumn(name = "food_id")
    private Food food;
    private int grams;
    private int totalCalories;
    private int totalCarbs;
    private int totalProtein;
    private int totalFats;


    @ManyToOne
    @JoinColumn(name = "daily_macros_id")
    @JsonIgnore
    private DailyMacros dailyMacros;


    public FoodEntry(TimeCategory category, Food food, int grams, int totalCalories, int totalCarbs, int totalProtein, int totalFats) {
        this.category = category;
        this.food = food;
        this.grams = grams;
        this.totalCalories = totalCalories;
        this.totalCarbs = totalCarbs;
        this.totalProtein = totalProtein;
        this.totalFats = totalFats;

    }

    public FoodEntry(TimeCategory category, Food food, int grams) {
        this.category = category;
        this.food = food;
        this.grams = grams;

        float multiplier= grams / 100.0f;
        this.totalCalories = Math.round(food.getCalories() * multiplier);
        this.totalCarbs = Math.round(food.getCarbs() * multiplier);
        this.totalProtein = Math.round(food.getProtein() * multiplier);
        this.totalFats = Math.round(food.getFats() * multiplier);

    }

    public void setGrams(int grams) {
        this.grams = grams;
        float multiplier = grams / 100.0f;
        this.totalCalories = Math.round(food.getCalories() * multiplier);
        this.totalCarbs = Math.round(food.getCarbs() * multiplier);
        this.totalProtein = Math.round(food.getProtein() * multiplier);
        this.totalFats = Math.round(food.getFats() * multiplier);
    }



}
