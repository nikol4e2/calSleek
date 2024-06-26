package com.example.calsleek.repository;

import com.example.calsleek.model.MacrosGoal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MacrosGoalRepository extends JpaRepository<MacrosGoal,Long> {
}
