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

class pickHabitVC: CustomTransitionViewController, iCarouselDelegate, iCarouselDataSource{

    @IBOutlet weak var habitCarousel: iCarousel!
    
    
    //Carousel variables
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
        
//        habitsCarouselPicker = habitCarouselSelector()
//        habitsCarouselPicker.habits = habitModel.getHabit()
        
        habitCarousel.delegate = self
        habitCarousel.dataSource = self
        
        habitCarousel.reloadData()
        habitCarousel.type = .custom
        habitCarousel.centerItemWhenSelected = true
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return habits.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: customWidth, height: customHeight))
        
        let habitImageView = UIImageView(image: habits[index].habitPic)
        habitImageView.frame = CGRect(x: 12.5, y: 0, width: 150, height: 175)
        habitImageView.contentMode = .scaleAspectFit
        view.addSubview(habitImageView)
        
        let habitNameLabel = UILabel()
        habitNameLabel.frame = CGRect(x: 12.5, y: 195, width: 150, height: 30)
        habitNameLabel.text = habits[index].habitName
        habitNameLabel.textColor = .white
        habitNameLabel.textAlignment = .center
        habitNameLabel.font = UIFont(name: "D-DIN", size: 26)
        habitNameLabel.adjustsFontSizeToFitWidth = true
        habitNameLabel.minimumScaleFactor = 0.2
        view.addSubview(habitNameLabel)
        
        return view
    }
    
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == iCarouselOption.spacing {
            return value * 1
        }
        if option == iCarouselOption.visibleItems {
            return CGFloat(habits.count)
        }
        if option == iCarouselOption.wrap {
            return CGFloat(truncating: true)
        }
        return value
    }
    


    
    func carousel(_ _carousel: iCarousel, itemTransformForOffset offset: CGFloat, baseTransform transform: CATransform3D) -> CATransform3D {
        let distance: CGFloat = 350.0
        //number of pixels to move the items away from camera
        let spacing: CGFloat = 0.7
        //extra spacing for center item
        let clampedOffset: CGFloat = min(1.0, max(-1.0, offset))
        let z = CGFloat(-fabs(Float(clampedOffset))) * distance
        let offsetFactor = offset + clampedOffset*spacing
        return CATransform3DTranslate(transform, offsetFactor * 175, 0.0, z)
        
    }


    @IBAction func nextScreen(_ sender: Any) {
        let selectedHabit = habits[habitCarousel.currentItemIndex]
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let habitInfo = storyBoard.instantiateViewController(withIdentifier: "habitInfoVCID") as! habitInfoVC
        habitInfo.chosenHabit = selectedHabit
        view.window?.layer.add(rightTransition(duration: 0.5), forKey: nil)
        self.present(habitInfo, animated: false, completion: nil)
    }
    
    
    
}
