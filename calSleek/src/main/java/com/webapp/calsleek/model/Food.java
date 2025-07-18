package com.webapp.calsleek.model;


import jakarta.annotation.Nullable;
import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@Entity
public class Food {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    private String name;
    private String brand;
    private int calories;
    private int carbs;
    private int protein;
    private int fats;
    private boolean isVerified;

    @ManyToOne
    @JoinColumn(name = "created_by_id")
    private User createdBy;


    public Food(boolean isVerified, int fats, int protein, int carbs, int calories, String name) {
        this.isVerified = isVerified;
        this.fats = fats;
        this.protein = protein;
        this.carbs = carbs;
        this.calories = calories;
        this.name = name;
        this.createdBy = null;
    }

    public Food(String name, int calories, int carbs, int protein, int fats, boolean isVerified, User createdBy) {
        this.name = name;
        this.calories = calories;
        this.carbs = carbs;
        this.protein = protein;
        this.fats = fats;
        this.isVerified = isVerified;
        this.createdBy = createdBy;
    }


}
