package com.webapp.calsleek.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Data
@Entity
public class DailyMacros {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    private LocalDateTime date;
    @OneToMany(mappedBy = "dailyMacros", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<FoodEntry> foodEntries;
    private int totalCalories;

    @OneToMany(mappedBy = "dailyMacros", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ExerciseLog> exercises;
    private int totalBurnedCalories;



    public DailyMacros() {
        this.exercises = new ArrayList<>();
        this.totalCalories = 0;
        this.totalBurnedCalories = 0;
        this.foodEntries=new ArrayList<>();
    }

    public DailyMacros(LocalDateTime date,User user) {
        this.date = date;
        this.exercises = new ArrayList<>();
        this.totalCalories = 0;
        this.totalBurnedCalories = 0;
        this.foodEntries=new ArrayList<>();

    }
}
