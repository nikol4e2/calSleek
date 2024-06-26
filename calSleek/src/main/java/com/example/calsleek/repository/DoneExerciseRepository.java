package com.example.calsleek.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DoneExerciseRepository extends JpaRepository<DoneExerciseRepository,Long> {

}
