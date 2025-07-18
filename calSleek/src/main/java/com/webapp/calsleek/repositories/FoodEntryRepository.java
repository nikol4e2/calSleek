package com.webapp.calsleek.repositories;

import com.webapp.calsleek.model.FoodEntry;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FoodEntryRepository extends JpaRepository<FoodEntry, Long> {
}
