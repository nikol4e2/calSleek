package com.webapp.calsleek.model.dtos;


import lombok.Data;

@Data
public class FoodDto {
    private String name;
    private String brand;
    private int calories;
    private int carbs;
    private int protein;
    private int fat;
    private Long userId;
    private boolean isVerified;
}
