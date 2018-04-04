//
//  pickHabitVC.swift
//  Habits
//
//  Created by Ahsan Vency on 3/29/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class pickHabitVC: UIViewController{

    @IBOutlet weak var habitCarousel: iCarousel!
    @IBOutlet weak var backgroundImg: UIImageView!
    
    var habits = habitModel.getHabit()
    let customWidth:CGFloat = 200
    let customHeight:CGFloat = 200
    
    
    var habitsCarouselPicker: habitCarouselSelector!
    
    var rotationAngle: CGFloat!
    let width: CGFloat = 100
    let height: CGFloat = 100
    
    //Creating the variable
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImg.bigBlurImage(targetImageView: backgroundImg, with: .light)
        
        habitsCarouselPicker = habitCarouselSelector()
        habitsCarouselPicker.habits = habitModel.getHabit()
        
        habitCarousel.delegate = habitsCarouselPicker
        habitCarousel.dataSource = habitsCarouselPicker
        
        habitCarousel.reloadData()
        habitCarousel.type = .linear
        habitCarousel.centerItemWhenSelected = true
    }
    
    
    @IBAction func next(_ sender: Any) {
        let selectedHabit = habitsCarouselPicker.habits[habitCarousel.currentItemIndex]
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let habitInfo = storyBoard.instantiateViewController(withIdentifier: "habitInfoVCID") as! habitInfoVC
        habitInfo.chosenHabit = selectedHabit
        
        view.window?.layer.add(rightTransition(), forKey: nil)
        self.present(habitInfo, animated: false, completion: nil)
        
    }
    
    @IBAction func Logout(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.remove(key: KEY_UID)
        try! Auth.auth().signOut()
        //        dismiss(animated: true, completion: nil)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "loginID") as! loginVC
        self.present(newViewController, animated: true, completion: nil)
    }

}
