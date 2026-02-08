package com.webapp.calsleek.web;

import com.webapp.calsleek.model.Goal;
import com.webapp.calsleek.model.dtos.GoalDto;
import com.webapp.calsleek.model.exceptions.GoalNotFoundException;
import com.webapp.calsleek.services.GoalService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/goal")
public class GoalController {

    private final GoalService goalService;


    public GoalController(GoalService goalService) {
        this.goalService = goalService;
    }

    @GetMapping("/{id}")
    public ResponseEntity<Goal> getGoalById(@PathVariable Long id) {
        if(this.goalService.findById(id).isPresent()){
            return ResponseEntity.ok(this.goalService.findById(id).get());
        }
        return ResponseEntity.notFound().build();
    }




    @PostMapping
    public ResponseEntity<Goal> createGoal(@Valid @RequestBody GoalDto goalDto) {
        Goal goal=this.goalService.saveGoal(goalDto.getActivityLevel(),goalDto.getWeight(),goalDto.getHeight(),goalDto.getAge(),goalDto.getGoalType(),goalDto.getIsMale(), goalDto.getUserId());
        return ResponseEntity.status(HttpStatus.CREATED).body(goal);

    }




    @PutMapping("/{id}")
    public ResponseEntity<Goal> updateGoal(@PathVariable Long id, @Valid @RequestBody GoalDto goalDto) {
        Goal goal=this.goalService.findById(id).orElseThrow(()->new GoalNotFoundException());
        this.goalService.editGoal(id,goalDto.getActivityLevel(),goalDto.getWeight(),goalDto.getHeight(),goalDto.getAge(),goalDto.getGoalType(),goalDto.getIsMale());
        return ResponseEntity.ok(goal);
    }



    @DeleteMapping("/{id}")
    public ResponseEntity<Goal> deleteGoalById(@PathVariable Long id) {
        this.goalService.deleteGoal(id);
        if(!this.goalService.findById(id).isPresent()){
            return ResponseEntity.ok().build();
        }
        return ResponseEntity.notFound().build();
    }
}
