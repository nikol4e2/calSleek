package com.webapp.calsleek.model.dtos;

import com.webapp.calsleek.model.Food;
import com.webapp.calsleek.model.enums.TimeCategory;
import jakarta.persistence.CascadeType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class FoodEntryDto {
    private TimeCategory category;
    private Food food;
    private int grams;
    private int totalCalories;
    private int totalCarbs;
    private int totalProtein;
    private int totalFats;


    public FoodEntryDto(Food food, TimeCategory category, int grams) {
        this.category = category;
        this.food = food;
        this.grams = grams;

        float multiplier= grams / 100.0f;
        this.totalCalories = Math.round(food.getCalories() * multiplier);
        this.totalCarbs = Math.round(food.getCarbs() * multiplier);
        this.totalProtein = Math.round(food.getProtein() * multiplier);
        this.totalFats = Math.round(food.getFats() * multiplier);
    }
}
