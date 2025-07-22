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


    public ExerciseLog(Exercise exercise, int durationInMinutes) {
        this.exercise = exercise;
        this.durationInMinutes = durationInMinutes;
        this.totalBurnedCalories=durationInMinutes* exercise.getCaloriesBurnedPerMinute();
    }


}
