//
//  advRewardsPopup.swift
//  Habits
//
//  Created by Ahsan Vency on 2/19/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit

class advRewardsPopup: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    
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
    
    var advReward: String?
    
    @IBOutlet weak var advRewardField: fancyField!
    @IBOutlet weak var advRewardPicker: UIPickerView!
    
    var listOfAdvRewards = ["New Tatto or Piercing", "Pedicure", "Take a Day Off", "Go Shopping", "Party", "Go Camping", "Weekend Trip","Other"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        advRewardField.text = "Pick your advanced reward below."
        advRewardField.textColor = maroonColor
        listOfAdvRewards.sort()
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return listOfAdvRewards.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = listOfAdvRewards[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:UIFont(name: "Avenir Next", size: 15.0)!,NSAttributedStringKey.foregroundColor:maroonColor])
        return myTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        //The user cannot edit the components anymore
        self.view.endEditing(true)
        //This is the value that was selected by the picker
        return listOfAdvRewards[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        advReward = self.listOfAdvRewards[row]
        if advReward == "Other"{
            self.advRewardField.becomeFirstResponder()
        }
        self.advRewardField.text = advReward!
        advStr = advReward
        self.advRewardPicker.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.advRewardField {
            

            if advReward != "Other"{
                self.advRewardPicker.isHidden = false
                textField.endEditing(true)
            } 

        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

            advReward = textField.text


    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.advRewardField.endEditing(true)

    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        if advRewardField.text != "" {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let advRewardInfo = storyBoard.instantiateViewController(withIdentifier: "NewHabitVCID") as! NewHabitVC
            advRewardInfo.whyLblText = whyLblText!
            advRewardInfo.weekArray = weekArray
            advRewardInfo.whenLblText = whenLblText!
            advRewardInfo.whereLblText = whereLblText!
            advRewardInfo.basicStr = basicStr!
            advRewardInfo.basicReward1 = basicReward1!
            advRewardInfo.basicReward2 = basicReward2!
            advRewardInfo.intStr = intStr!
            advRewardInfo.intReward1 = intReward1!
            advRewardInfo.intReward2 = intReward2!
            advRewardInfo.advStr = advStr!
            advRewardInfo.currentText = currentText!
            advRewardInfo.editButtonPressed = 1
            self.present(advRewardInfo,animated: true, completion: nil)
        }
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
