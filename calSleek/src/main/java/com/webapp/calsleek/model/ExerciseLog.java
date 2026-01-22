package com.webapp.calsleek.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@Entity
public class ExerciseLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @ManyToOne
    @JoinColumn(name = "exercise_id")
    private Exercise exercise;
    private int durationInMinutes;
    private int totalBurnedCalories;

    @ManyToOne
    @JoinColumn(name = "daily_macros_id")
    private DailyMacros dailyMacros;


    public ExerciseLog(Exercise exercise, int durationInMinutes,DailyMacros dailyMacros) {
        this.exercise = exercise;
        this.durationInMinutes = durationInMinutes;
        this.totalBurnedCalories=durationInMinutes* exercise.getCaloriesBurnedPerMinute();
        this.dailyMacros=dailyMacros;
    }


}
