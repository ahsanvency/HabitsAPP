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
    //Creates an array for all the habits to be in the array titled "habits"
    var habits = habitModel.getHabit()
    //Sets the height and width of each view
    let customWidth:CGFloat = 200
    let customHeight:CGFloat = 200
//    var habitsCarouselPicker: habitCarouselSelector!
    
    
    
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
    
    
    //Sets up the image and label to be shown in the view
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        //A general view we add the image and label to for the habits
        let view = UIView(frame: CGRect(x: 0, y: 0, width: customWidth, height: customHeight))
        
        //Gets the image for the habit object
        //Each image is stored in assets as the name of the habit
        let habitImageView = UIImageView(image: habits[index].habitPic)
        habitImageView.frame = CGRect(x: 12.5, y: 0, width: 150, height: 175)
        habitImageView.contentMode = .scaleAspectFit
        view.addSubview(habitImageView)
        
        //Same with the images we are taking the name parameter of each habit and displaying it on the iCarousel
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
    
    
    //Code I found online that we need to keep but don't understand why
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


    //Goes to the next screen where the user will enter information about their habit
    @IBAction func nextScreen(_ sender: Any) {
        let selectedHabit = habits[habitCarousel.currentItemIndex]
        //This is how you do a transition in code
        //We have to do it this way if we want to pass variables like the habit object from on VC to another
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let habitInfo = storyBoard.instantiateViewController(withIdentifier: "habitInfoVCID") as! habitInfoVC
        //Sends over the habit object the user selected to the habitInfo screen for us to use
        habitInfo.chosenHabit = selectedHabit
        view.window?.layer.add(rightTransition(duration: 0.5), forKey: nil)
        self.present(habitInfo, animated: false, completion: nil)
    }
    
    
    
}
