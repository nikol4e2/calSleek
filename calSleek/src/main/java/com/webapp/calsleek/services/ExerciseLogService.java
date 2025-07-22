package com.webapp.calsleek.services;

import com.webapp.calsleek.model.ExerciseLog;

import java.util.Optional;

public interface ExerciseLogService {
    ExerciseLog save(Long exerciseId, int minutesPerformed);
    Optional<ExerciseLog> findById(Long id);
    ExerciseLog edit(Long id, int minutesPerformed);
    void delete(Long id);

}
