//
//  onboardingViewController.swift
//  Habits
//
//  Created by Ahsan Vency on 4/11/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit
import paper_onboarding

//How all the onboarding stuff is displayed
//The initial screen you only see when you first download the app

class onboardingVC: UIViewController, PaperOnboardingDataSource, PaperOnboardingDelegate {

    
    @IBOutlet weak var onboardingView: OnboardingView!
    
    @IBOutlet weak var startHabitsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func onboardingItemsCount() -> Int {
        return 3
    }
    
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        
        let titleFont = UIFont(name: "D-DIN-BOLD", size: 30)
        let descriptionFont = UIFont(name: "D-DIN", size: 22)
        
        //Setting the different colors for the onboarding views
        let colorBlue = UIColor(red:13/255, green:76/255, blue:153/255, alpha:0.85)
        let colorRed = UIColor(red:186/255, green:7/255, blue: 29/255, alpha:0.85)
//        let colorPurple = UIColor(red:102/255, green:23/255, blue: 108/255, alpha:0.8)
        let colorGreen = UIColor(red:34/255, green:139/255, blue: 34/255, alpha:0.8)
        
        //Sets the image for the bottom circles, we want them to be clear so this makes it clear
        let alphaImageView = UIImageView(image: UIImage(named: "clearCircle"))
        alphaImageView.alpha = 0
        
        return [
            //Each one of these is a screen
            //Self Explanatory how its set up
            OnboardingItemInfo(informationImage: UIImage(named: "Aristotle")!, title: "Habits Are Everything", description: " \n \"We are what we repeatedly do. Excellence, then, is not an act, but a habit.\" ~ Aristotle",pageIcon: alphaImageView.image!, color: colorBlue, titleColor: .white, descriptionColor: UIColor.white, titleFont: titleFont!, descriptionFont: descriptionFont!),
            
            OnboardingItemInfo(informationImage: UIImage(named: "Intrinsic1")!, title: "Consistency and Goal Setting", description: " \n There are a few questions to help you stay consistent and set goals." ,pageIcon: alphaImageView.image!, color: colorRed, titleColor: .white, descriptionColor: UIColor.white, titleFont: titleFont!, descriptionFont: descriptionFont!),
            
            OnboardingItemInfo(informationImage: UIImage(named: "Interval Reinforcement")!, title: "Interval Reinforcement", description: " \n There are three tiers of rewards because random rewards are fun and proven to be the best way to develop habits.",pageIcon: alphaImageView.image!, color: colorGreen, titleColor: .white, descriptionColor: UIColor.white, titleFont: titleFont!, descriptionFont: descriptionFont!)][index]
    }
    
    func onboardingConfigurationItem(_: OnboardingContentViewItem, index _: Int) {
        
    }
    
    //Makes the button appear when they reach the final screen for onboarding
    func onboardingWillTransitonToIndex(_ index: Int) {
        if index == 1{
            if self.startHabitsButton.alpha == 1 {
                UIView.animate(withDuration: 0.2) {
                    self.startHabitsButton.alpha = 0
                }
            }
        }
    }
    
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 2{
            UIView.animate(withDuration: 0.5) {
                self.startHabitsButton.alpha = 1
            }
        }
    }
    
    //Sets the userDefaults for the onboarding being done so it will not come up next time the user opens the app
    @IBAction func onboardingDone(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "onBoardingComplete")
        userDefaults.synchronize()
    }
    
}
