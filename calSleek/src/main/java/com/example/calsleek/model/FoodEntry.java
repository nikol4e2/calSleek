package com.example.calsleek.model;

import lombok.Data;

@Data
public class FoodEntry {

    private Food food;
    private float grams;
    private float totalCalories;
    private float totalCarbs;
    private float totalProtein;
    private float totalFats;

    public FoodEntry(Food food, float grams) {
        this.food = food;
        this.grams = grams;
        float multiplyValue=(float)grams/100;
        this.totalCalories=food.getCalories()*multiplyValue;
        this.totalCarbs=food.getCarbs()*multiplyValue;
        this.totalFats=food.getFats()*multiplyValue;
        this.totalProtein=food.getProtein()*multiplyValue;

    }
}
