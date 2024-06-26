package com.example.calsleek.service.impl;

import com.example.calsleek.model.Exercise;
import com.example.calsleek.repository.ExerciseRepository;
import com.example.calsleek.service.ExerciseService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ExerciseServiceImpl implements ExerciseService {

    private final ExerciseRepository exerciseRepository;

    public ExerciseServiceImpl(ExerciseRepository exerciseRepository) {
        this.exerciseRepository = exerciseRepository;
    }

    @Override
    public List<Exercise> findAll() {
        return exerciseRepository.findAll();
    }

    @Override
    public Optional<Exercise> findByName(String name) {
        return exerciseRepository.findByName(name);
    }

    @Override
    public Exercise save(String name, int caloriesBurnedPerMin) {
        return exerciseRepository.save(new Exercise(name,caloriesBurnedPerMin));
    }

    @Override
    public void deleteByName(String name) {
        exerciseRepository.deleteByName(name);
    }
}
