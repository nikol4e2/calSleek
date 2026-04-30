package com.webapp.calsleek.repositories;

import com.webapp.calsleek.model.Food;
import com.webapp.calsleek.model.FoodEntry;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
@Repository
public interface FoodEntryRepository extends JpaRepository<FoodEntry, Long> {


}
