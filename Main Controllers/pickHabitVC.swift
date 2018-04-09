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
import TransitionButton

class pickHabitVC: CustomTransitionViewController{

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
    
    let button = TransitionButton(frame: CGRect(x: 30, y: 452, width: 315, height: 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        backgroundImg.bigBlurImage(targetImageView: backgroundImg, with: .light)
        
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
        
        view.window?.layer.add(rightTransition(duration: 0.5), forKey: nil)
        self.present(habitInfo, animated: false, completion: nil)
        
    }
    
    @IBAction func Logout(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        try! Auth.auth().signOut()
        //        dismiss(animated: true, completion: nil)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "loginID") as! loginVC
        view.window?.layer.add(bottomTransition(duration: 0.5), forKey: nil)
        self.present(newViewController, animated: false, completion: nil)
    }

}
