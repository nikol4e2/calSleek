package com.webapp.calsleek.services;

import com.webapp.calsleek.model.Exercise;

import java.util.List;
import java.util.Optional;

public interface ExerciseService {
    Optional<Exercise> getExerciseById(Long id);
    List<Exercise> getAllExercises();
    Exercise saveExercise(String name, int caloriesBurnedPerMinute);
    Exercise editExercise(Long id, String name, int caloriesBurnedPerMinute);
    void deleteExercise(Long id);



}
