package com.webapp.calsleek.repositories;

import com.webapp.calsleek.model.ExerciseLog;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ExerciseLogRepository extends JpaRepository<ExerciseLog, Long> {
}
