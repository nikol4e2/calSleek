package com.example.calsleek.repository;

import com.example.calsleek.model.Food;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface FoodRepository extends JpaRepository<Food,String> {

    Optional<Food> findByName(String name);
    void deleteByName(String name);

}
