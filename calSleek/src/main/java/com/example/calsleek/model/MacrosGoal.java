package com.example.calsleek.model;


import lombok.Data;

import java.util.Date;

@Data
public class MacrosGoal {
    private Long id;
    private Date date;
    private int calories;
    private int protein;
    private int carbs;
    private int fats;

}
