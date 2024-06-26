package com.example.calsleek.service;

import com.example.calsleek.model.DailyMacros;
import com.example.calsleek.model.MacrosGoal;
import com.example.calsleek.model.User;

import java.util.Date;

public interface UserService {

    User login(String username,String password);
    User register(String username, String password, String repeatPassword, String name, String surname, Date dateOfBirth, float weight, DailyMacros dailyMacros);
    User save(User user);
    User edit(String username, String password, String repeatPassword, String name, String surname, Date dateOfBirth);
    User changeMacrosGoal(String username, MacrosGoal macrosGoal);
}
