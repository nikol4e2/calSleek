package com.webapp.calsleek.services.impl;

import com.webapp.calsleek.model.Exercise;
import com.webapp.calsleek.model.exceptions.ExerciseAlreadyExistsException;
import com.webapp.calsleek.model.exceptions.ExerciseNotFoundException;
import com.webapp.calsleek.repositories.ExerciseRepository;
import com.webapp.calsleek.services.ExerciseService;
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
    public Optional<Exercise> getExerciseById(Long id) {
        return this.exerciseRepository.findById(id);
    }

    @Override
    public List<Exercise> getAllExercises() {
        return this.exerciseRepository.findAll();
    }

    @Override
    public Exercise saveExercise(String name, int caloriesBurnedPerMinute) {
        if(this.exerciseRepository.findByName(name).isPresent())
        {
            throw new ExerciseAlreadyExistsException();
        }
        Exercise exercise=new Exercise(name,caloriesBurnedPerMinute);
        return this.exerciseRepository.save(exercise);
    }

    @Override
    public Exercise editExercise(Long id, String name, int caloriesBurnedPerMinute) {
        Exercise exercise=this.exerciseRepository.findById(id).orElseThrow(()->new ExerciseNotFoundException(id));
        exercise.setName(name);
        exercise.setCaloriesBurnedPerMinute(caloriesBurnedPerMinute);
        return this.exerciseRepository.save(exercise);
    }

    @Override
    public void deleteExercise(Long id) {
        if(this.exerciseRepository.findById(id).isPresent())
        {
            this.exerciseRepository.deleteById(id);
        }
    }
}
