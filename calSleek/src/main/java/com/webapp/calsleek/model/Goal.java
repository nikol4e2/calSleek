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
    private int calories;
    private int carbs;
    private int proteins;
    private int fats;
    @Enumerated(EnumType.STRING)
    private GoalType goalType;

    public Goal(ActivityLevel activityLevel, float weight, int calories, int carbs, int proteins, int fats, GoalType goalType) {
        this.activityLevel = activityLevel;
        this.weight = weight;
        this.calories = calories;
        this.carbs = carbs;
        this.proteins = proteins;
        this.fats = fats;
        this.goalType = goalType;
    }
}
