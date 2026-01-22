package com.webapp.calsleek.model;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Data
@Entity
@Table(uniqueConstraints = @UniqueConstraint(columnNames = {"user_id", "date"}))
public class DailyMacros {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private LocalDateTime date;
    @OneToMany(mappedBy = "dailyMacros", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<FoodEntry> foodEntries;
    private int totalCalories;
    private int totalCarbs;
    private int totalProteins;
    private int totalFats;

    @OneToMany(mappedBy = "dailyMacros", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ExerciseLog> exercises;
    private int totalBurnedCalories;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    public DailyMacros() {
        this.exercises = new ArrayList<>();
        this.totalCalories = 0;
        this.totalBurnedCalories = 0;
        this.foodEntries=new ArrayList<>();
        this.totalCarbs = 0;
        this.totalProteins = 0;
        this.totalFats = 0;

    }

    public DailyMacros(LocalDateTime date,User user) {
        this.date = date;
        this.exercises = new ArrayList<>();
        this.totalCalories = 0;
        this.totalBurnedCalories = 0;
        this.foodEntries=new ArrayList<>();
        this.totalCarbs = 0;
        this.totalProteins = 0;
        this.totalFats = 0;
        this.user=user;


    }




    public void addFoodEntry(FoodEntry foodEntry) {
        this.foodEntries.add(foodEntry);
        this.totalCalories+=foodEntry.getTotalCalories();
        this.totalCarbs+=foodEntry.getTotalCarbs();
        this.totalProteins += foodEntry.getTotalProtein();
        this.totalFats += foodEntry.getTotalFats();
    }

    public void removeFoodEntry(Long foodEntryId) {
        FoodEntry toRemove = this.foodEntries.stream()
                .filter(fe -> fe.getId().equals(foodEntryId))
                .findFirst()
                .orElse(null);

        if (toRemove != null) {
            this.totalCalories -= toRemove.getTotalCalories();
            this.totalCarbs -= toRemove.getTotalCarbs();
            this.totalProteins -= toRemove.getTotalProtein();
            this.totalFats -= toRemove.getTotalFats();
            toRemove.setDailyMacros(null);
            this.foodEntries.remove(toRemove);
        }

    }


    public void addExerciseLog(ExerciseLog exerciseLog) {
        this.exercises.add(exerciseLog);
        this.totalBurnedCalories+=exerciseLog.getTotalBurnedCalories();
    }

    public void removeExerciseLog(Long exerciseLogId) {
        ExerciseLog toRemove=this.exercises.stream().filter(e->e.getId().equals(exerciseLogId)).findFirst().orElse(null);
        if (toRemove != null) {
            this.totalBurnedCalories-=toRemove.getTotalBurnedCalories();
            toRemove.setDailyMacros(null);
            this.exercises.remove(toRemove);
        }
    }
}
