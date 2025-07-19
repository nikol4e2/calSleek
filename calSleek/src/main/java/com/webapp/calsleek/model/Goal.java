package com.webapp.calsleek.model;

import com.webapp.calsleek.model.enums.ActivityLevel;
import com.webapp.calsleek.model.enums.GoalType;
import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;


@Data
@NoArgsConstructor
@Entity
public class Goal {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Enumerated(EnumType.STRING)
    private ActivityLevel activityLevel;
    private float weight;
    private int height;
    private int age;
    private int calories;
    private int carbs;
    private int proteins;
    private int fats;
    private Boolean isMale;
    @Enumerated(EnumType.STRING)
    private GoalType goalType;


    public Goal(ActivityLevel activityLevel, float weight, int height, int age, GoalType goalType, Boolean isMale) {
        this.activityLevel = activityLevel;
        this.weight = weight;
        this.height = height;
        this.age = age;
        this.goalType = goalType;
        this.isMale = isMale;
        calculateCalories();
    }


    public void calculateCalories() {
        double bmr;
        if(isMale) {
            bmr = 10*weight+6.25*height-5*age+5;
        }else{
            bmr = 10*weight+6.25*height-5*age-161;
        }


        double activityFactor=switch (activityLevel)
        {
            case NOT_VERY_ACTIVE -> 1;
            case LIGHTLY_ACTIVE -> 1.25;
            case ACTIVE -> 1.375;
            case VERY_ACTIVE -> 1.55;
        };
        double calories=bmr*activityFactor;

        calories +=switch (goalType){
            case LOSE_1KGR_PER_WEEK -> -1000;
            case LOSE_500GR_PER_WEEK -> -500;
            case MAINTAIN -> 0;
            case GAIN_500GR_PER_WEEK -> 500;
            case GAIN_1KGR_PER_WEEK -> 1000;
        };
        int dailyCalories=(int) Math.round(calories);
        this.calories=dailyCalories;
        this.carbs=(int)((dailyCalories*0.4)/4);
        this.proteins=(int)((dailyCalories*0.3)/4);
        this.fats=(int)((dailyCalories*0.3)/9);

    }
}
