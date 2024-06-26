package com.example.calsleek.service.impl;


import com.example.calsleek.exceptions.InvalidDateException;
import com.example.calsleek.exceptions.InvalidUserCredentialsException;
import com.example.calsleek.exceptions.PasswordsDoNotMatchException;
import com.example.calsleek.exceptions.UserNameAlreadyExistsException;
import com.example.calsleek.model.DailyMacros;
import com.example.calsleek.model.MacrosGoal;
import com.example.calsleek.model.User;
import com.example.calsleek.model.Weight;
import com.example.calsleek.repository.UserRepository;
import com.example.calsleek.repository.WeightRepository;
import com.example.calsleek.service.UserService;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;

@Service
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final WeightRepository weightRepository;


    public UserServiceImpl(UserRepository userRepository, WeightRepository weightRepository) {
        this.userRepository = userRepository;
        this.weightRepository = weightRepository;
    }

    @Override
    public User login(String username, String password) {
        if(username==null || username.isEmpty() || password==null || password.isEmpty())
        {
            throw new InvalidUserCredentialsException();
        }
        return userRepository.findByUsernameAndPassword(username,password).orElseThrow(InvalidUserCredentialsException::new);
    }

    @Override
    public User register(String username, String password, String repeatPassword, String name, String surname, Date dateOfBirth, float weight, DailyMacros dailyMacros) {
        if(username==null || username.isEmpty() || password==null || password.isEmpty())
        {
            throw new InvalidUserCredentialsException();
        }
        if(!password.equals(repeatPassword))
        {
            throw new PasswordsDoNotMatchException();
        }
        if(this.userRepository.findByUsername(username).isPresent() || !this.userRepository.findByUsername(username).isEmpty())
        {
            throw new UserNameAlreadyExistsException(username);
        }
        Date date=Date.from(LocalDate.now().minusYears(5).atStartOfDay(ZoneId.systemDefault()).toInstant());
        if(dateOfBirth.after(date))
        {
            throw new InvalidDateException();

        }
        Weight weightObj=weightRepository.save(new Weight(weight,Date.from(LocalDate.now().atStartOfDay(ZoneId.systemDefault()).toInstant())));
        User user=new User(username,name,surname,password,dateOfBirth,weightObj);
        return this.userRepository.save(user);
    }

    @Override
    public User save(User user) {
        return this.userRepository.save(user);
    }

    @Override
    public User edit(String username, String password, String repeatPassword, String name, String surname, Date dateOfBirth) {
        User user=(User) this.userRepository.findByUsername(username).get();
        if(user!=null) {
            if (!password.equals(repeatPassword)) {
                throw new PasswordsDoNotMatchException();
            }
            Date date = Date.from(LocalDate.now().minusYears(5).atStartOfDay(ZoneId.systemDefault()).toInstant());
            if (dateOfBirth.after(date)) {
                throw new InvalidDateException();

            }
            user.setBirth(dateOfBirth);
            user.setPassword(password);
            user.setName(name);
        }
        return this.userRepository.save(user);
    }

    @Override
    public User changeMacrosGoal(String username, MacrosGoal macrosGoal) {
        User user=(User) this.userRepository.findByUsername(username).get();
        if(user!=null)
        {
            user.setMacrosGoal(macrosGoal);
        }
        return userRepository.save(user);
    }
}
