//
//  pickHabitVC.swift
//  Habits
//
//  Created by Ahsan Vency on 3/29/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit

class pickHabitVC: UIViewController{

    
    @IBOutlet weak var habitPicker: UIPickerView!
    
    var rotationAngle: CGFloat!
    let width: CGFloat = 100
    let height: CGFloat = 100
    
    let habitList = ["Running","Meditating","Waking Up Early","Coding","Journaling", "Eating Healthy", "Praying", "Reading", "Act of Kindness", "Lifting", "Sleeping on Time"]
    
    
    
    //Creating the variable
    var habitsPicker: habitSelector!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        rotationAngle = -90 * (.pi/180)
        
        var y = habitPicker.frame.origin.y
        
        habitPicker.transform = CGAffineTransform(rotationAngle: rotationAngle)
        habitPicker.frame = CGRect(x: -50, y: y, width: view.frame.width + 100, height: 100)
        
        //Object to give the data to the connected picker
        habitsPicker = habitSelector()
        habitsPicker.habits = habitModel.getHabit()
        
        habitPicker.delegate = habitsPicker
        habitPicker.dataSource = habitsPicker
    }
    
    
    @IBAction func next(_ sender: Any) {
        let selectedHabit = habitPicker.selectedRow(inComponent: 0)
        let habitName = habitsPicker.habits[selectedHabit].habitName
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let habitInfo = storyBoard.instantiateViewController(withIdentifier: "habitInfoVCID") as! habitInfoVC
        habitInfo.habitName = habitName
        self.present(habitInfo, animated: true, completion: nil)
    }
    

}
