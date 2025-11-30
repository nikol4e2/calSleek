package com.webapp.calsleek.web;

import com.webapp.calsleek.model.ExerciseLog;
import com.webapp.calsleek.model.dtos.ExerciseLogDto;
import com.webapp.calsleek.services.ExerciseLogService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
public class ExerciseLogController {


    private final ExerciseLogService exerciseLogService;


    public ExerciseLogController(ExerciseLogService exerciseLogService) {
        this.exerciseLogService = exerciseLogService;
    }

    @GetMapping("/{id}")
    public ResponseEntity<ExerciseLog> getExerciseLog(@PathVariable Long id) {
        ExerciseLog exerciseLog = exerciseLogService.findById(id).get();
        if (exerciseLog == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(exerciseLog);
    }

    @PostMapping()
    public ResponseEntity<ExerciseLog> saveExerciseLog(@RequestBody ExerciseLogDto exerciseLogDto) {
        ExerciseLog exerciseLog=this.exerciseLogService.save(exerciseLogDto.getExerciseId(), exerciseLogDto.getDurationInMinutes());
        return ResponseEntity.ok(exerciseLog);
    }

    @PutMapping("/{id}")
    public ResponseEntity<ExerciseLog> editExerciseLog(@PathVariable Long id, @RequestBody ExerciseLogDto exerciseLogDto) {
        ExerciseLog exerciseLog=this.exerciseLogService.edit(id,exerciseLogDto.getDurationInMinutes());
        if (exerciseLog == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(exerciseLog);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ExerciseLog> deleteExerciseLog(@PathVariable Long id) {
        this.exerciseLogService.delete(id);
        return ResponseEntity.noContent().build();
    }




}
