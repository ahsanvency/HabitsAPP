//
//  NewHabitVC.swift
//  Habits
//
//  Created by Ahsan Vency on 1/4/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper


class NewHabitVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate{
    
    
    
    //Variables
    var habitRow: Int = 0
    var habitName: String = "Running"
    
    var whyLblText: String = "Tap to Edit"
    var weekArray = [Int]()
    var whenLblText:String = "Tap to Edit"
    var whereLblText:String = "Tap to Edit"
    var currentText:String = ""
    
    var basicStr: String = "Tap To Edit Rewards"
    var intStr: String = "Tap To Edit Rewards"
    var advStr: String = "Tap To Edit Rewards"
    
    var basicReward1: String = ""
    var basicReward2: String = ""
    
    var intReward1: String = ""
    var intReward2: String = ""
    
    var advReward: String = ""
    
    var editButtonPressed = 0
    
    //Why, When, Where habit labels
    @IBOutlet weak var whyLbl: UILabel!
    @IBOutlet weak var whenLbl: UILabel!
    @IBOutlet weak var whereLbl: UILabel!
    @IBOutlet weak var basicLbl: UILabel!
    @IBOutlet weak var intLbl: UILabel!
    @IBOutlet weak var advLbl: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewInScroll: UIView!
    
    //The Labels for the textField and the picker
    @IBOutlet weak var textBox: UITextField!
    @IBOutlet weak var dropDown: UIPickerView!
    @IBOutlet weak var habitPic: UIImageView!
    @IBOutlet weak var logoutBtn: UIButton!
    
    
    
    //creates the list for the picker view
    //Add more if you see fit
    var list = ["Running","Meditating","Waking Up Early","Coding","Journaling", "Eating Healthy", "Praying", "Reading", "Act of Kindness", "Lifting", "Sleeping on Time","other"]
    
    var listDict = ["running":"run","meditating":"meditate","waking up early":"wake up early","coding":"code","journaling":"journal", "eating healthy":"eat healthy", "praying":"pray", "reading":"read", "act of kindness":"perform an act of kindness", "lifting":"lift", "sleeping on time":"sleep on time","other":"other"]
    
    var intrinsicDict = ["running": "Feel Healthier or Enhance Mood", "meditating":"Peace of Mind or Inner Purity", "waking up early":"Be More Productive or Have More Time", "coding":"Learn a New Skill or Solve Problems", "journaling":"Calm Emotions or Better Emotional Intelligence", "eating healthy":"Feel Cleaner or Have More Energy", "praying":"Feel at Peace or Show Gratitude", "reading":"Gain Knowledge or Stimulate Imagination", "act of kindness":"Better Relationships or Pay it Forward", "lifting":"Physical Health or Enhance Mood", "sleeping on time":"More Energy or Better Focus","other":"other"]
    
    var list2 = ["run","meditate","wake up early","code","journal", "eat healthy", "pray", "read", "perform an act of kindness", "lift", "sleep on time","other"]
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        if editButtonPressed != 0{
            startAnimation()
        }
    }
    
    //Starts off with just the picker for editing
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
        //added touch events to views
        addTouchEvents()
    }
    
    func upAlert (messages: String) {
        let myAlert = UIAlertController(title: "Alert", message: messages, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return list.count
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = list[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:UIFont(name: "Avenir Next", size: 15.0)!,NSAttributedStringKey.foregroundColor:satinColor])
        return myTitle
    }
    
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//        var label: UILabel
//        if let view = view as? UILabel { label = view }
//        else { label = UILabel() }
//
//        label.textColor = maroonColor
//        label.text = getTextForPicker(atRow: row)
//
//        return label
//    }
    
    //Functionality for the pickerView and the textfield that works with it
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        //The user cannot edit the components anymore
        self.view.endEditing(true)
        //This is the value that was selected by the picker
        return list[row]
    }
    
    //Whatever picker spot was selected the "row" will know
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textBox.endEditing(true)
        //What value was selected by the user
        habitRow = row
        habitName = self.list[row];
        currentText = self.list[row];
        if currentText == "other"{
            self.textBox.becomeFirstResponder()
        }
        self.textBox.text = habitName; //Sets the name of the textBox to the habit name
        self.dropDown.isHidden = true; //Hides the Drop Down Menu because something was selected
        self.habitPic.isHidden = false;
        self.habitPic.image = UIImage(named: habitName); //Changes the pic to correspond with the habit
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.textBox {
            self.dropDown.isHidden = false;
            habitPic.isHidden = true
            //if you dont want the users to see the keyboard type:
            if currentText == "other"{
                
            } else {
                textField.endEditing(true)
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.textBox {
            habitName = textField.text!
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textBox.endEditing(true)
    }
    
    
    
    @IBOutlet weak var WhyView: fancyView!
    @IBOutlet weak var WhenView: fancyView!
    @IBOutlet weak var whereView: fancyView!
    @IBOutlet weak var basicView: fancyView!
    @IBOutlet weak var intView: fancyView!
    @IBOutlet weak var advView: fancyView!
    
    
    
    
    func addTouchEvents(){
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.onWhyViewTapped(sender:)))
        self.WhyView.addGestureRecognizer(gesture)
        
        let whenGesture = UITapGestureRecognizer(target: self, action:  #selector (self.onWhenViewTapped(sender:)))
        self.WhenView.addGestureRecognizer(whenGesture)
        
        let whereGesture = UITapGestureRecognizer(target: self, action:  #selector (self.onWhereViewTapped(sender:)))
        self.whereView.addGestureRecognizer(whereGesture)
        
        let chooseHabitGesture = UITapGestureRecognizer(target: self, action:  #selector (self.onHabitPicTapped(sender:)))
        self.habitPic.addGestureRecognizer(chooseHabitGesture)
        
        let basicGesture = UITapGestureRecognizer(target: self, action:  #selector (self.basicViewTapped(sender:)))
        self.basicView.addGestureRecognizer(basicGesture)
        
        let intGesture = UITapGestureRecognizer(target: self, action:  #selector (self.intViewTapped(sender:)))
        self.intView.addGestureRecognizer(intGesture)
        
        let advGesture = UITapGestureRecognizer(target: self, action:  #selector (self.advViewTapped(sender:)))
        self.advView.addGestureRecognizer(advGesture)
        
//        let rewardsGesture1 = UITapGestureRecognizer(target: self, action:  #selector (self.onRewardsViewTapped(sender:)))
//        let rewardsGesture2 = UITapGestureRecognizer(target: self, action:  #selector (self.onRewardsViewTapped(sender:)))
//        let rewardsGesture3 = UITapGestureRecognizer(target: self, action:  #selector (self.onRewardsViewTapped(sender:)))
//
//        self.basicView.addGestureRecognizer(rewardsGesture1)
//        self.intView.addGestureRecognizer(rewardsGesture2)
//        self.advView.addGestureRecognizer(rewardsGesture3)
    }
    
    @objc func onHabitPicTapped(sender: UITapGestureRecognizer){
        self.dropDown.isHidden = false;
        habitPic.isHidden = true
    }
    
    @objc func onWhyViewTapped(sender: UITapGestureRecognizer){
        if currentText != ""{
            let storyBoard: UIStoryboard = UIStoryboard(name: "addPopups", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "whyPopup") as! whyPopupVC
            
            newViewController.whyLblText = whyLblText
            newViewController.habitName = habitName.lowercased() + "?"
            if let  intrinDictVal = intrinsicDict[habitName.lowercased()]{
                newViewController.intrinsicStatement = intrinDictVal
            } else {
                 newViewController.intrinsicStatement = habitName
            }
            
            newViewController.habitRow = habitRow
            newViewController.weekArray = weekArray
            newViewController.whenLblText = whenLblText
            newViewController.whereLblText = whereLblText
            newViewController.basicStr = basicStr
            newViewController.basicReward1 = basicReward1
            newViewController.basicReward2 = basicReward2
            newViewController.intStr = intStr
            newViewController.intReward1 = intReward1
            newViewController.intReward2 = intReward2
            newViewController.advStr = advStr
            newViewController.currentText = currentText

            self.present(newViewController, animated: true, completion: nil)} else {
            upAlert(messages: "Please select habit first")
        }

    }
    
    @objc func onWhenViewTapped(sender: UITapGestureRecognizer){
        if currentText != ""{
            let storyBoard: UIStoryboard = UIStoryboard(name: "addPopups", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "whenAddPopup") as! whenAddPopupVC
            
            newViewController.habitName =  habitName.lowercased() + "?"
            newViewController.whyLblText = whyLblText
            newViewController.weekArray = weekArray
            newViewController.whenLblText = whenLblText
            newViewController.whereLblText = whereLblText
            newViewController.basicStr = basicStr
            newViewController.basicReward1 = basicReward1
            newViewController.basicReward2 = basicReward2
            newViewController.intStr = intStr
            newViewController.intReward1 = intReward1
            newViewController.intReward2 = intReward2
            newViewController.advStr = advStr
            newViewController.currentText = currentText
            
            self.present(newViewController, animated: true, completion: nil)} else {
            upAlert(messages: "Please select habit first")
        }
    }
    
    @objc func onWhereViewTapped(sender: UITapGestureRecognizer){
        if currentText != ""{
            let storyBoard: UIStoryboard = UIStoryboard(name: "addPopups", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "whereAddPopup") as! whereAddPopupVC

            if let dicVal = listDict[habitName.lowercased()] {
                newViewController.habitName = dicVal + "?"
            } else {
                newViewController.habitName = habitName
            }
            
        
            newViewController.whyLblText = whyLblText
            newViewController.weekArray = weekArray
            newViewController.whenLblText = whenLblText
            newViewController.whereLblText = whereLblText
            newViewController.basicStr = basicStr
            newViewController.basicReward1 = basicReward1
            newViewController.basicReward2 = basicReward2
            newViewController.intStr = intStr
            newViewController.intReward1 = intReward1
            newViewController.intReward2 = intReward2
            newViewController.advStr = advStr
            newViewController.currentText = currentText
        self.present(newViewController, animated: true, completion: nil)} else {
    upAlert(messages: "Please select habit first")
    }
    }
    
    @objc func basicViewTapped(sender: UITapGestureRecognizer){
        if currentText != ""{
        let storyBoard: UIStoryboard = UIStoryboard(name: "addPopups", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "basicRewardPopup") as! basicRewardPopupVC
        
        
            if let dicVal = listDict[habitName.lowercased()] {
                newViewController.habitName = dicVal + "?"
            } else {
                newViewController.habitName = habitName
            }
        
        newViewController.whyLblText = whyLblText
        newViewController.weekArray = weekArray
        newViewController.whenLblText = whenLblText
        newViewController.whereLblText = whereLblText
        newViewController.basicStr = basicStr
        newViewController.basicReward1 = basicReward1
        newViewController.basicReward2 = basicReward2
        newViewController.intStr = intStr
        newViewController.intReward1 = intReward1
        newViewController.intReward2 = intReward2
        newViewController.advStr = advStr
        newViewController.currentText = currentText
        
            self.present(newViewController, animated: true, completion: nil) } else {
            upAlert(messages: "Please select habit first")
        }

    }
    
    @objc func intViewTapped(sender: UITapGestureRecognizer){
        if currentText != ""{
        let storyBoard: UIStoryboard = UIStoryboard(name: "addPopups", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "intRewardPopup") as! intRewardsPopupVC
        
        
            if let dicVal = listDict[habitName.lowercased()] {
                newViewController.habitName = dicVal + "?"
            } else {
                newViewController.habitName = habitName
            }
        
        newViewController.whyLblText = whyLblText
        newViewController.weekArray = weekArray
        newViewController.whenLblText = whenLblText
        newViewController.whereLblText = whereLblText
        newViewController.basicStr = basicStr
        newViewController.basicReward1 = basicReward1
        newViewController.basicReward2 = basicReward2
        newViewController.intStr = intStr
        newViewController.intReward1 = intReward1
        newViewController.intReward2 = intReward2
        newViewController.advStr = advStr
        newViewController.currentText = currentText
        
        self.present(newViewController, animated: true, completion: nil)} else {
    upAlert(messages: "Please select habit first")
    }

    }
    
    @objc func advViewTapped(sender: UITapGestureRecognizer){
        if currentText != ""{
        let storyBoard: UIStoryboard = UIStoryboard(name: "addPopups", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "advRewardPopup") as! advRewardsPopup
        
            if let dicVal = listDict[habitName.lowercased()] {
                newViewController.habitName = dicVal + "?"
            } else {
                newViewController.habitName = habitName
            }

        newViewController.whyLblText = whyLblText
        newViewController.weekArray = weekArray
        newViewController.whenLblText = whenLblText
        newViewController.whereLblText = whereLblText
        newViewController.basicStr = basicStr
        newViewController.basicReward1 = basicReward1
        newViewController.basicReward2 = basicReward2
        newViewController.intStr = intStr
        newViewController.intReward1 = intReward1
        newViewController.intReward2 = intReward2
        newViewController.advStr = advStr
        newViewController.currentText = currentText
        
            self.present(newViewController, animated: true, completion: nil)} else {
            upAlert(messages: "Please select habit first")
        }
    }
    
    @IBAction func addHabit(_ sender: Any) {
        if Auth.auth().currentUser?.uid != nil {
            
            //checks to see if txtFeilds are empty
            let valid = validateTextFeilds()
            if valid == true{
                
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
                let childUpdates = ["/Users/\(uid)/Habits/\(habitRefKey)": currentText]
                ref.updateChildValues(childUpdates)
                //Adding Habit to Habits node
                //This is where the information on the label needs to be changed
                DataService.ds.REF_HABITS.child(uid).removeValue()

                DataService.ds.REF_HABITS.child(uid).child(habitRefKey).setValue(["Why": whyLbl.text,"When":whenLbl.text,"Where":whereLbl.text,"name":currentText,"freq":weekArray])
                //Adding rewards to habit
                DataService.ds.REF_HABITS.child(uid).child(habitRefKey).child("Rewards").setValue(["basicReward1":basicReward1,"basicReward2":basicReward2,"intReward1":intReward1,"intReward2":intReward2,"Adv":advLbl.text, "Success": 0])
                
                //Segue
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainScreenViewCID") as! MainScreenViewC
                newViewController.firstTimeLoaded = 1;
                self.present(newViewController, animated: true){
                    self.startAnimation()
                } 
            } else {
                print("error")
            }
        }
    }
    
    
    func validateTextFeilds() -> Bool{
        if (whyLbl.text == "Tap to Edit") {
            //handel the errors properly
            self.upAlert(messages: "Please fill out Why.")
            return false
        }
        else if (whenLbl.text == "Tap to Edit"){
            
            self.upAlert(messages: "Please fill out When.")
            return false
        }
        else if (whereLbl.text == "Tap to Edit"){
            
            self.upAlert(messages: "Please fill out Where.")
            return false
        }
        else if (habitName == ""){
            
            self.upAlert(messages: "Please pick a Habit")
            return false
        }
        else if (basicStr == "Tap To Edit Rewards" || basicStr == ""){
            
            self.upAlert(messages: "Please enter Basic Rewards")
            return false
        }
        else if (intStr == "Tap To Edit Rewards" || intStr == ""){
            
            self.upAlert(messages: "Please enter Intermediate Rewards")
            return false
        }
        else if (advStr == "Tap To Edit Rewards" || advStr == ""){
            
            self.upAlert(messages: "Please enter an Advanced Reward")
            return false
        }
        else if textBox.text == "Pick your habit below"{
            
            self.upAlert(messages: "Please pick a Habit")
            return false
        }else {
            print("GOOD")
        }
        return true
    }
    
    @IBAction func Logout(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.remove(key: KEY_UID)
        try! Auth.auth().signOut()
        //        dismiss(animated: true, completion: nil)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainLoginID") as! MainLogin
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func startAnimation()
    {
        DispatchQueue.main.async(execute: {
            self.scrollView.setContentOffset(CGPoint(x: 0,y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height - 50), animated: true)
        })
    }
    
    func setupScreen(){
        logoutBtn.layer.borderColor = maroonColor.cgColor
        logoutBtn.setTitleColor(maroonColor, for: .normal)
        
        textBox.textColor = satinColor
        textBox.backgroundColor = seaFoamColor
        textBox.layer.borderColor = satinColor.cgColor
        
        
        viewInScroll.backgroundColor = seaFoamColor
        

        
        //Puts the list in alphabetical order
        list.sort()
        list2.sort()
        
        //Starts the screen with the habit pic being hidden
        habitPic.isHidden = true
        
        self.textBox.text = "Pick your habit below"
        
        //getting values from pop up
        whyLbl.text = whyLblText
        whenLbl.text = whenLblText
        whereLbl.text = whereLblText
        basicLbl.text = basicStr
        intLbl.text = intStr
        advLbl.text = advStr
        
        if currentText != ""{
            habitName = currentText
            self.habitPic.image = UIImage(named: currentText);
            self.habitPic.isHidden = false;
            self.dropDown.isHidden = true;
            self.textBox.text = currentText;
        }
    }
}


