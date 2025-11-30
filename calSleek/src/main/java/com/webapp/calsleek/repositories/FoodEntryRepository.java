package com.webapp.calsleek.repositories;

import com.webapp.calsleek.model.Food;
import com.webapp.calsleek.model.FoodEntry;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDateTime;
import java.util.List;

public interface FoodEntryRepository extends JpaRepository<FoodEntry, Long> {

    List<FoodEntry> findAllByUserByIdAndDate(Long userId, LocalDateTime date);
}
