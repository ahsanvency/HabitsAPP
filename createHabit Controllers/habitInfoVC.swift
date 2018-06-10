//
//  habitInfoVC.swift
//  Habits
//
//  Created by Ahsan Vency on 3/29/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class habitInfoVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var habitPic: UIImageView!
    @IBOutlet weak var habitNameLbl: UILabel!
    @IBOutlet weak var scrollInfo: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!

    
    //These have to be here and idk why but deleting them makes the app crash
    @IBOutlet var whySlideXib: whySlide!
    @IBOutlet var whereSlideXib: whereSlide!
    @IBOutlet var whenSlideXib: whenSlide!
    
    //sets up the chosenHabit from the pickHabitVC
    var chosenHabit: Habit!
    
    //These are the slides when we swipe on the screen to enter the info
    var whySlide: whySlide!
    var whereSlide: whereSlide!
    var whenSlide: whenSlide!
    var basicRewardsSlide: basicRewardsSlide!
    var intRewardsSlide: intRewardsSlide!
    var advRewardsSlide: advRewardsSlide!
    var confirmSlide: confirmSlide!
    
    var whyXibView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
    }
    
    //The alert function we want to simplify so we dont have to call it on each VC all the time
    func upAlert (messages: String) {
        let myAlert = UIAlertController(title: "Alert", message: messages, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    //Creates the slides to go across
    func createSlides() -> [UIView]{
        
        //Need this for each specific slide we put across
        whySlide = Bundle.main.loadNibNamed("whySlide", owner: self, options: nil)!.first as! whySlide
        //This is a label on the whySlide.xib we connected to the whySlide file so we can access it here becasue it is an object of whySlide
        //Also for chosenHabit.intrinsic reason is that way becasue its part of the object and easy to access
        whySlide.intrinsicLabel.text = "Did you know intrinsic reasons like \(chosenHabit.intrinsicReason) help you succeed?"
        whySlide.questionLabel.text = "Why would you like to start \(chosenHabit.habitName)?"
        
        
        //The remaining slides are the same as the why slide with differences being easy to understand
        whereSlide = Bundle.main.loadNibNamed("whereSlide", owner: self, options: nil)!.first as! whereSlide
        whereSlide.consistencyLabel.text = "Did you know being consistent with time and places helps you develop the habit of \(chosenHabit.habitName)?"
        whereSlide.questionLabel.text = "Where can you consistently \(chosenHabit.habitVerb)?"
        
        
        whenSlide = Bundle.main.loadNibNamed("whenSlide", owner: self, options: nil)!.first as! whenSlide
        whenSlide.questionLabel.text = "When can you consistently \(chosenHabit.habitVerb)?"
        
        basicRewardsSlide = Bundle.main.loadNibNamed("basicRewardsSlide", owner: self, options: nil)!.first as! basicRewardsSlide
        intRewardsSlide = Bundle.main.loadNibNamed("intRewardsSlide", owner: self, options: nil)!.first as! intRewardsSlide
        advRewardsSlide = Bundle.main.loadNibNamed("advRewardsSlide", owner: self, options: nil)!.first as! advRewardsSlide
        confirmSlide = Bundle.main.loadNibNamed("confirmSlide", owner: self, options: nil)!.first as! confirmSlide
        return [whySlide, whereSlide, whenSlide, basicRewardsSlide, intRewardsSlide, advRewardsSlide, confirmSlide]
    }
    
    
    //There is a scroll view setup with the slides in it so we can scroll through it correctly
    func setupscrollInfo(Slides:[UIView]){
        scrollInfo.frame = CGRect(x: 0, y: 0, width: scrollInfo.frame.width, height: scrollInfo.frame.height)
        scrollInfo.contentSize = CGSize(width: CGFloat(scrollInfo.frame.width) * CGFloat(Slides.count), height: scrollInfo.frame.height)
        //Lets us see what specific page we are on for the scrolling of the app
        scrollInfo.isPagingEnabled = true
        
        //sets up each of the slides for how many slides there are
        for i in 0..<Slides.count{
            Slides[i].frame = CGRect(x: (scrollInfo.frame.width) * CGFloat(i), y: 0, width: scrollInfo.frame.width, height: scrollInfo.frame.height)
            scrollInfo.addSubview(Slides[i])
        }
    }
    
    //Everytime we scroll it updates the pageControl dots on the bottom of the scrollView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/scrollInfo.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
    //button from confirmSlide.xib we are accessing here becasue we set the file owner to this VC
    @IBAction func confirmHabit(_ sender: Any) {
        whenSlide.save()
        
        if Auth.auth().currentUser?.uid != nil {
            
            //Makes sure all the infomation is filled out
            if validateTextFeilds(){
                
                //database instance
                var ref: DatabaseReference!
                ref = Database.database().reference()
                
                //current user
                guard let user = Auth.auth().currentUser else {
                    return
                }
                let uid = user.uid
                
                //getting key of habits list
                let habitRefKey = ref.child("Users").child(uid).child("Habits").childByAutoId().key
                //Values to add to Habits list
                let childUpdates = ["/Users/\(uid)/Habits/\(habitRefKey)": chosenHabit.habitName]
                ref.updateChildValues(childUpdates)
                //Adding Habit to Habits node
                //This is where the information on the label needs to be changed
                DataService.ds.REF_HABITS.child(uid).removeValue()
                
                DataService.ds.REF_HABITS.child(uid).child(habitRefKey).setValue(["Why": whySlide.whyField.text!,"When":"\(whenSlide.daysOfWeekStr)\(whenSlide.timeStr)","Where":whereSlide.whereField.text!,"name":chosenHabit.habitName,"freq":whenSlide.weekArray])
                //Adding rewards to habit
                DataService.ds.REF_HABITS.child(uid).child(habitRefKey).child("Rewards").setValue(["basicReward1":basicRewardsSlide.basicField1.text!,"basicReward2":basicRewardsSlide.basicField2.text!,"intReward1":intRewardsSlide.intField1.text!,"intReward2":intRewardsSlide.intField2.text!,"advReward":advRewardsSlide.advField.text!, "Success": 0])
                
                //Segue
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let mainViewController = storyBoard.instantiateViewController(withIdentifier: "mainVCID") as! MainVC
                //                newViewController.firstTimeLoaded = 1;
                self.present(mainViewController, animated: true){
                }
            } else {
                print("error")
            }
        }
    }
    
    
    func validateTextFeilds() -> Bool{
        if (whySlide.whyField.text == "") {
            //Shows them when they had an error each time they do
            self.upAlert(messages: "Please fill out Why.")
            return false
        }
        else if (whereSlide.whereField.text == ""){
            
            self.upAlert(messages: "Please fill out Where.")
            return false
        }
        else if whenSlide.daysOfWeekStr == "" {
            self.upAlert(messages: "Please fill out the days you wish to \(chosenHabit.habitVerb)")
        }
        else if (whenSlide.timeStr == ""){
            
            self.upAlert(messages: "Please fill out a time to \(chosenHabit.habitVerb)")
            return false
        }
        else if (basicRewardsSlide.basicField1.text == "Tap to pick a basic reward." || basicRewardsSlide.basicField1.text == "" || basicRewardsSlide.basicField1.text == "Enter Custom Reward Above" || basicRewardsSlide.basicField2.text == "Tap to pick a basic reward." || basicRewardsSlide.basicField2.text == "" || basicRewardsSlide.basicField2.text == "Enter Custom Reward Above"){
            
            self.upAlert(messages: "Please enter both Basic Rewards")
            return false
        }
        else if (intRewardsSlide.intField1.text == "Tap to pick an intermediate reward." || intRewardsSlide.intField1.text == "" || intRewardsSlide.intField1.text == "Enter Custom Reward Above" || intRewardsSlide.intField2.text == "Tap to pick an intermediate reward." || intRewardsSlide.intField2.text == "" || intRewardsSlide.intField2.text == "Enter Custom Reward Above"){
            
            self.upAlert(messages: "Please enter both Intermediate Rewards")
            return false
        }
        else if (advRewardsSlide.advField.text == "Tap to pick an advanced reward." || advRewardsSlide.advField.text == "" || advRewardsSlide.advField.text == "Enter Custom Rewards Above"){
            
            self.upAlert(messages: "Please enter an Advanced Reward")
            return false
        }
        else {

        }
        return true
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
    
    @IBAction func back(_ sender: Any) {
        view.window?.layer.add(leftTransition(duration: 0.5), forKey: nil)
        dismiss(animated: false, completion: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= (220)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += (220)
            }
        }
    }
    
    func setupScreen(){
        //Sets the image to the habit they chose but in blue
        habitPic.image = UIImage(named: "\(chosenHabit.habitName) Blue")
        habitNameLbl.text = chosenHabit.habitName
        scrollInfo.delegate = self
        let Slides:[UIView] = createSlides()
        setupscrollInfo(Slides: Slides)
        pageControl.numberOfPages = Slides.count
        pageControl.currentPage = 0
        pageControl.tintColor = blueColor
        scrollInfo.layer.cornerRadius = 10.0
        view.bringSubview(toFront: pageControl)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.hideKeyboardWhenTappedAround()
    }
    
}
