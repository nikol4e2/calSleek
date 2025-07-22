package com.webapp.calsleek.model;

import com.webapp.calsleek.model.enums.TimeCategory;
import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@Entity
public class FoodEntry {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Enumerated(EnumType.STRING)
    private TimeCategory category;

    @ManyToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "food_id")
    private Food food;
    private int grams;
    private int totalCalories;
    private int totalCarbs;
    private int totalProtein;
    private int totalFats;


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
        //TODO CALCULATE MACROS
    }



}
