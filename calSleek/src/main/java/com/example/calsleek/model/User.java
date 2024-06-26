package com.example.calsleek.model;

import lombok.Data;

import java.util.Date;
import java.util.List;

@Data
public class User {
    private String name;
    private String surname;
    private String password;
    private Date birth;
    private List<Weight> weightList;
    private List<DailyMacros> dailyMacros;
    private MacrosGoal macrosGoal;
}
