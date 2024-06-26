package com.example.calsleek.model;

import lombok.Data;

@Data
public class DoneExercise {

    private Exercise exercise;
    private int minPerformed;
    private int totalCaloriesBurned;

    public DoneExercise(Exercise exercise, int minPerformed) {
        this.exercise = exercise;
        this.minPerformed = minPerformed;
        this.totalCaloriesBurned=minPerformed* exercise.getCaloriesBurnedPerMinute();
    }

}
