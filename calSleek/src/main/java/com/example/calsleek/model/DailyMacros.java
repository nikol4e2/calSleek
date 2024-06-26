package com.example.calsleek.model;

import lombok.Data;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Data
public class DailyMacros {

    private Date date;
    private MacrosGoal goal;
    private List<DoneExercise> doneExercises;
    private List<FoodEntry> foodEntries;

    public DailyMacros(Date date, MacrosGoal goal) {
        this.date = date;
        this.goal = goal;
        this.doneExercises=new ArrayList<>();
        this.foodEntries=new ArrayList<>();
    }
}
