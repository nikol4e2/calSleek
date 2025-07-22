package com.webapp.calsleek.services.impl;

import com.webapp.calsleek.model.Exercise;
import com.webapp.calsleek.model.ExerciseLog;
import com.webapp.calsleek.model.exceptions.ExerciseNotFoundException;
import com.webapp.calsleek.repositories.ExerciseLogRepository;
import com.webapp.calsleek.repositories.ExerciseRepository;
import com.webapp.calsleek.services.ExerciseLogService;
import org.springframework.stereotype.Service;

import java.util.Optional;
@Service
public class ExerciseLogServiceImpl implements ExerciseLogService {

    private final ExerciseLogRepository exerciseLogRepository;
    private final ExerciseRepository exerciseRepository;

    public ExerciseLogServiceImpl(ExerciseLogRepository exerciseLogRepository, ExerciseRepository exerciseRepository) {
        this.exerciseLogRepository = exerciseLogRepository;
        this.exerciseRepository = exerciseRepository;
    }

    @Override
    public ExerciseLog save(Long exerciseId, int minutesPerformed) {
        Exercise exercise=this.exerciseRepository.findById(exerciseId).orElseThrow(() -> new ExerciseNotFoundException(exerciseId));
        ExerciseLog exerciseLog=new ExerciseLog(exercise,minutesPerformed);
        return this.exerciseLogRepository.save(exerciseLog);
    }

    @Override
    public Optional<ExerciseLog> findById(Long id) {
        return this.exerciseLogRepository.findById(id);
    }

    @Override
    public ExerciseLog edit(Long id, int minutesPerformed) {
        ExerciseLog exerciseLog=this.exerciseLogRepository.findById(id).orElseThrow(() -> new ExerciseNotFoundException(id));
        exerciseLog.setDurationInMinutes(minutesPerformed);
        return this.exerciseLogRepository.save(exerciseLog);
    }

    @Override
    public void delete(Long id) {
        if(this.exerciseLogRepository.existsById(id)) {
            this.exerciseLogRepository.deleteById(id);
        }
    }
}
