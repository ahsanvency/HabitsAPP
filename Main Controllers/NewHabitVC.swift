//
//  NewHabitVC.swift
//  Habits
//
//  Created by Ahsan Vency on 1/4/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit
import Firebase



class NewHabitVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate{
    
    
    //Variables
    var habitRow: Int = 0
    var habitName: String = "Running"
    
    var whyLblText: String = "Tap to Edit"
    var weekArray = [Int]()
    var whenLblText:String = "Tap to Edit"
    var whereLblText:String = "Tap to Edit"
    var currentText:String = ""
    
    var basicStr: String = "Enter Basic Rewards"
    var intStr: String = "Enter Intermediate Rewards"
    var advStr: String = "Enter Advanced Rewards"
    
    var editButtonPressed = 0
    
    //Why, When, Where habit labels
    @IBOutlet weak var whyLbl: UILabel!
    @IBOutlet weak var whenLbl: UILabel!
    @IBOutlet weak var whereLbl: UILabel!
    @IBOutlet weak var basicLbl: UILabel!
    @IBOutlet weak var intLbl: UILabel!
    @IBOutlet weak var advLbl: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    //The Labels for the textField and the picker
    @IBOutlet weak var textBox: UITextField!
    @IBOutlet weak var dropDown: UIPickerView!
    @IBOutlet weak var habitPic: UIImageView!
    
    
    //creates the list for the picker view
    //Add more if you see fit
    var list = ["Running","Meditating","Waking Up Early","Coding","Journaling", "Eating Healthy", "Praying", "Reading", "Daily Act of Kindness", "Lifting", "Sleeping on Time"]
    
    var listDict = ["running":"run","meditating":"meditate","waking up early":"wake up early","coding":"code","journaling":"journal", "eating healthy":"eat healthy", "praying":"pray", "reading":"read", "daily act of kindness":"perform an act of kindness", "lifting":"lift", "sleeping on time":"sleep on time"]
    var list2 = ["run","meditate","wake up early","code","journal", "eat healthy", "pray", "read", "perform an act of kindness", "lift", "sleep on time"]
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        if editButtonPressed != 0{
            startAnimation()
        }
        print(editButtonPressed)
    }
    
    //Starts off with just the picker for editing
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
        //added touch events to views
        addTouchEvents()
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return list.count
    }
    
    //Functionality for the pickerView and the textfield that works with it
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        //The user cannot edit the components anymore
        self.view.endEditing(true)
        //This is the value that was selected by the picker
        return list[row]
    }
    
    //Whatever picker spot was selected the "row" will know
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //What value was selected by the user
        habitRow = row
        habitName = self.list[row];
        currentText = self.list[row];
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
            textField.endEditing(true)
        }
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
        
//        let rewardsGesture1 = UITapGestureRecognizer(target: self, action:  #selector (self.onRewardsViewTapped(sender:)))
//        let rewardsGesture2 = UITapGestureRecognizer(target: self, action:  #selector (self.onRewardsViewTapped(sender:)))
//        let rewardsGesture3 = UITapGestureRecognizer(target: self, action:  #selector (self.onRewardsViewTapped(sender:)))
//
//        self.basicView.addGestureRecognizer(rewardsGesture1)
//        self.intView.addGestureRecognizer(rewardsGesture2)
//        self.advView.addGestureRecognizer(rewardsGesture3)
    }
    
    @objc func onWhyViewTapped(sender: UITapGestureRecognizer){
        
            let storyBoard: UIStoryboard = UIStoryboard(name: "addPopups", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "whyPopup") as! whyPopupVC
            
            newViewController.whyLblText = whyLblText
            newViewController.habitName = habitName.lowercased() + "?"
            newViewController.habitRow = habitRow
            newViewController.weekArray = weekArray
            newViewController.whenLblText = whenLblText
            newViewController.whereLblText = whereLblText
            newViewController.basicStr = basicStr
            newViewController.intStr = intStr
            newViewController.advStr = advStr
            newViewController.currentText = currentText

            self.present(newViewController, animated: true, completion: nil)

    }
    
    @objc func onWhenViewTapped(sender: UITapGestureRecognizer){
        
            let storyBoard: UIStoryboard = UIStoryboard(name: "addPopups", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "whenAddPopup") as! whenAddPopupVC
            
            newViewController.habitName =  habitName.lowercased() + "?"
            newViewController.whyLblText = whyLblText
            newViewController.weekArray = weekArray
            newViewController.whenLblText = whenLblText
            newViewController.whereLblText = whereLblText
            newViewController.basicStr = basicStr
            newViewController.intStr = intStr
            newViewController.advStr = advStr
            newViewController.currentText = currentText
            
            self.present(newViewController, animated: true, completion: nil)
    }
    
    @objc func onWhereViewTapped(sender: UITapGestureRecognizer){
        
            let storyBoard: UIStoryboard = UIStoryboard(name: "addPopups", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "whereAddPopup") as! whereAddPopupVC
            

            newViewController.habitName =  listDict[habitName.lowercased()]! + "?"
            newViewController.whyLblText = whyLblText
            newViewController.weekArray = weekArray
            newViewController.whenLblText = whenLblText
            newViewController.whereLblText = whereLblText
            newViewController.basicStr = basicStr
            newViewController.intStr = intStr
            newViewController.advStr = advStr
            newViewController.currentText = currentText
        
            self.present(newViewController, animated: true, completion: nil)

    }
    
    
    
    @IBAction func editRewardsBtn(_ sender: Any) {

        let storyBoard: UIStoryboard = UIStoryboard(name: "addPopups", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "rewardsPopupVC") as! rewardsPopupVC
        
        
        newViewController.habitName =  list2[habitRow].lowercased() + "?"
        newViewController.whyLblText = whyLblText
        newViewController.weekArray = weekArray
        newViewController.whenLblText = whenLblText
        newViewController.whereLblText = whereLblText
        newViewController.basicStr = basicStr
        newViewController.intStr = intStr
        newViewController.advStr = advStr
        newViewController.currentText = currentText
        
        self.present(newViewController, animated: true, completion: nil)
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
                DataService.ds.REF_HABITS.child(uid).child(habitRefKey).child("Rewards").setValue(["Basic":basicLbl.text,"Int":intLbl.text,"Adv":advLbl.text, "Success": 0])
                
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
            print("Error1")
            return false
        }
        if (whenLbl.text == "Tap to Edit"){
            print("Error2")
            return false
        }
        if (whereLbl.text == "Tap to Edit"){
            print("Error3")
            return false
        }

        if (habitName == ""){
            print("Error7")
            return false
        }
        if (basicStr == "Enter Basic Rewards"){
            print("Error8")
            return false
        }
        if (intStr == "Enter Intermediate Rewards"){
            print("Error9")
            return false
        }
        if (advStr == "Enter Advanced Rewards"){
            print("Error10")
            return false
        }
        if textBox.text == "Pick your habit below"{
            print("error 11")
            return false
        }
        
        return true
    }
    
    func startAnimation()
    {
        DispatchQueue.main.async(execute: {
            self.scrollView.setContentOffset(CGPoint(x: 0,y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height - 13), animated: true)
        })
    }
}


