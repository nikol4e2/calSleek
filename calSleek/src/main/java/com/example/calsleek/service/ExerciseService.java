package com.example.calsleek.service;

import com.example.calsleek.model.Exercise;

import java.util.List;
import java.util.Optional;

public interface ExerciseService {

    List<Exercise> findAll();
    Optional<Exercise> findByName(String name);

    Exercise save(String name,int caloriesBurnedPerMin);
    void deleteByName(String name);
}
