package com.example.calsleek.model;

import lombok.Data;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Data
public class User {
    private String username;
    private String name;
    private String surname;
    private String password;
    private LocalDate birth;
    private List<Weight> weightList;
    private List<DailyMacros> dailyMacros;
    private MacrosGoal macrosGoal;

    public User(String username, String name, String surname, String password, LocalDate birth, Weight weight) {
        this.username = username;
        this.name = name;
        this.surname = surname;
        this.password = password;
        this.birth = birth;
        this.weightList=new ArrayList<>();
        this.weightList.add(weight);
        this.dailyMacros=new ArrayList<>();
        macrosGoal=null;

    }
}
