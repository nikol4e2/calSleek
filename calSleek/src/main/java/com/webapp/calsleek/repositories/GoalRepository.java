package com.webapp.calsleek.repositories;

import com.webapp.calsleek.model.Goal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface GoalRepository extends JpaRepository<Goal, Long> {

    Optional<Goal> findTopByUserIdOrderByIdDesc(Long userId);
}
