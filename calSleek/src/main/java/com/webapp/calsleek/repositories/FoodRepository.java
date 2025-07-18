package com.webapp.calsleek.repositories;

import com.webapp.calsleek.model.Food;
import com.webapp.calsleek.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface FoodRepository extends JpaRepository<Food, Long> {

    Optional<Food> findByNameContainsOrBrandContainingIgnoreCase(String name,  String brand);
    List<Food> getAllByCreatedBy(User user);
}
