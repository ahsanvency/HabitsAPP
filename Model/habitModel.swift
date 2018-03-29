//
//  habitModel.swift
//  Habits
//
//  Created by Ahsan Vency on 3/29/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import Foundation
import UIKit

class habitModel{
    class func getHabit() -> [Habit] {
        
        var habits = [Habit]()
        
        let habitList = ["Running","Meditating","Waking Up Early","Coding","Journaling", "Eating Healthy", "Praying", "Reading", "Act of Kindness", "Lifting", "Sleeping On Time"]
        
        habits.append(Habit(habitName: "Running", habitPic: UIImage(named: "Running")!))
        habits.append(Habit(habitName: "Meditating", habitPic: UIImage(named: "Meditating")!))
        habits.append(Habit(habitName: "Waking Up Early", habitPic: UIImage(named: "Waking Up Early")!))
        habits.append(Habit(habitName: "Coding", habitPic: UIImage(named: "Coding")!))
        habits.append(Habit(habitName: "Journaling", habitPic: UIImage(named: "Journaling")!))
        habits.append(Habit(habitName: "Eating Healthy", habitPic: UIImage(named: "Eating Healthy")!))
        habits.append(Habit(habitName: "Praying", habitPic: UIImage(named: "Praying")!))
        habits.append(Habit(habitName: "Reading", habitPic: UIImage(named: "Reading")!))
        habits.append(Habit(habitName: "Act of Kindness", habitPic: UIImage(named: "Act of Kindness")!))
        habits.append(Habit(habitName: "Lifting", habitPic: UIImage(named: "Lifting")!))
        habits.append(Habit(habitName: "Sleeping On Time", habitPic: UIImage(named: "Sleeping On Time")!))
        
        
        return habits 
    }
}
