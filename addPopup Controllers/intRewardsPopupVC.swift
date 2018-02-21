//
//  intRewardsPopupVC.swift
//  Habits
//
//  Created by Ahsan Vency on 2/19/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit

class intRewardsPopupVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    var habitRow: Int?
    var habitName: String?
    var whyLblText: String?
    var weekArray = [Int]()
    var whenLblText:String?
    var whereLblText:String?
    var currentText:String?
    
    var basicStr: String?
    var intStr: String?
    var advStr: String?
    
    var basicReward1: String?
    var basicReward2: String?
    
    var intReward1: String?
    var intReward2: String?
    
    @IBOutlet weak var intField1: fancyField!
    @IBOutlet weak var intPicker1: UIPickerView!
    @IBOutlet weak var intField2: fancyField!
    @IBOutlet weak var intPicker2: UIPickerView!
    
    var listOfIntRewards1 = ["Eat Out", "Dessert", "Watch TV", "Call a Friend", "Enjoy a Long Shower", "Visit Library", "Work on Your Hobby", "Buy a New Game", "Buy a New Book","Other"]
    var listOfIntRewards2 = ["Eat Out", "Dessert", "Watch TV", "Call a Friend", "Enjoy a Long Shower", "Visit Library", "Work on Your Hobby", "Buy a New Game", "Buy a New Book","Other"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
        
    }
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = listOfIntRewards1[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:UIFont(name: "Avenir Next", size: 15.0)!,NSAttributedStringKey.foregroundColor:maroonColor])
        return myTitle
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        var countRow : Int = listOfIntRewards1.count
        
        if pickerView == intPicker2{
            countRow = listOfIntRewards2.count
        }
        
        return countRow
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == intPicker1{
            let reward = listOfIntRewards1[row]
            return reward
        }else if pickerView == intPicker2{
            let reward = listOfIntRewards2[row]
            return reward
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == intPicker1{
            intReward1 = self.listOfIntRewards1[row]
            
            if intReward1 == "Other"{
                self.intField1.becomeFirstResponder()
            }
            self.intField1.text = intReward1!
            self.intPicker1.isHidden = true
            self.intField2.isHidden = false
            self.intField2.isEnabled = true
            
        }else if pickerView == intPicker2{
            intReward2 = self.listOfIntRewards2[row]
            if intReward2 == "Other"{
                self.intField2.becomeFirstResponder()
            }
            self.intField2.text = intReward2
            self.intPicker2.isHidden = true
            self.intField1.isEnabled = true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.intField1{
            self.intPicker1.isHidden = false
            self.intField2.isHidden = true
            
            if intReward1 != "Other"{
            intField2.isEnabled = false
                textField.endEditing(true)}
            
        }
        if textField == self.intField2{
            self.intPicker2.isHidden = false
            if intReward2 != "Other"{
            textField.endEditing(true)
                intField1.isEnabled = false}
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.intField1 {
            intReward1 = textField.text
        }
        if textField == self.intField2{
            intReward2 = textField.text
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.intField2.endEditing(true)
        self.intField1.endEditing(true)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if intField1.text != "Pick your intermediate reward below." && intField2.text != "Pick your intermediate reward below."{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let intRewardInfo = storyBoard.instantiateViewController(withIdentifier: "NewHabitVCID") as! NewHabitVC
            intRewardInfo.whyLblText = whyLblText!
            intRewardInfo.weekArray = weekArray
            intRewardInfo.whenLblText = whenLblText!
            intRewardInfo.whereLblText = whereLblText!
            intRewardInfo.basicStr = basicStr!
            intRewardInfo.basicReward1 = basicReward1!
            intRewardInfo.basicReward2 = basicReward2!
            intRewardInfo.intStr = "\(intReward1!) or \(intReward2!)"
            intRewardInfo.intReward1 = intReward1!
            intRewardInfo.intReward2 = intReward2!
            intRewardInfo.advStr = advStr!
            intRewardInfo.currentText = currentText!
            self.present(intRewardInfo,animated: true, completion: nil)
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupScreen(){
        intField1.text = "Pick your intermediate reward below."
        intField2.text = "Pick your intermediate reward below."
        intField1.textColor = maroonColor
        intField2.textColor = maroonColor
        listOfIntRewards1.sort()
        listOfIntRewards2.sort()
    }
}
