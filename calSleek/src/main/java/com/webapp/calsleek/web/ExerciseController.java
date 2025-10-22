package com.webapp.calsleek.web;

import com.webapp.calsleek.model.Exercise;
import com.webapp.calsleek.model.dtos.ExerciseDto;
import com.webapp.calsleek.services.ExerciseService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/exercise")
public class ExerciseController {

    private final ExerciseService exerciseService;

    public ExerciseController(ExerciseService exerciseService) {
        this.exerciseService = exerciseService;
    }

    @GetMapping
    public ResponseEntity<List<Exercise>> getAllExercises() {
        List<Exercise> exercises = exerciseService.getAllExercises();
        if(exercises.isEmpty())
        {
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        }
        return new ResponseEntity<>(exercises, HttpStatus.OK);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Exercise> getExerciseById(@PathVariable Long id) {
        Optional<Exercise> exercise = exerciseService.getExerciseById(id);
        if (exercise.isPresent()) {
            return new ResponseEntity<>(exercise.get(), HttpStatus.OK);
        }
        return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }


    @PostMapping
    public ResponseEntity<Exercise> createExercise(@RequestBody ExerciseDto exerciseDto) {

        if(exerciseDto.getCaloriesBurnedPerMinute() > 0 && !exerciseDto.getName().isEmpty()) {
            Exercise exercise = this.exerciseService.saveExercise(exerciseDto.getName(), exerciseDto.getCaloriesBurnedPerMinute());
            return new ResponseEntity<>(exercise, HttpStatus.CREATED);
        }
        return new ResponseEntity<>(HttpStatus.BAD_REQUEST);


    }

    @PutMapping("/{id}")
    public ResponseEntity<Exercise> updateExercise(@PathVariable Long id,@RequestBody ExerciseDto exerciseDto) {
        this.exerciseService.editExercise(id, exerciseDto.getName(), exerciseDto.getCaloriesBurnedPerMinute());
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Exercise> deleteExercise(@PathVariable Long id) {
        this.exerciseService.deleteExercise(id);
        if(exerciseService.getExerciseById(id).isPresent())
        {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }






}
