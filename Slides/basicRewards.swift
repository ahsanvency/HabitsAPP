//
//  Slide.swift
//  Habits
//
//  Created by Ahsan Vency on 3/29/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit

class basicRewardsSlide: UIView, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var basicField1: UITextField!
    @IBOutlet weak var basicPicker1: UIPickerView!
    @IBOutlet weak var basicField2: UITextField!
    
//https:www.youtube.com/watch?v=SfjZwgxlwcc
//That link should explain how the picker menu works on the basic and intermediate screens
//Things are commented out because we initially had two pickers one for each reward now we have one picker for the first reward and just a textfield for the second reward
    
    var listOfBasicRewards1 = ["Chocolate", "Candy", "Sweet Drink", "Use Lottery Ticket", "Watch TV", "Play Video Games"]
    
//    var listOfBasicRewards2 = [String]()
    
    //How the basic rewards are stored
    var basicReward1: String?
    var basicReward2: String?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        listOfBasicRewards2 = listOfBasicRewards1
        
        //Setting the delegate
        basicField1.delegate = self
        basicField2.delegate = self
        
        basicPicker1.delegate = self
        basicPicker1.dataSource = self
//        basicPicker2.delegate = self
//        basicPicker2.dataSource = self
        
        basicField1.text = "Tap to pick first Basic Reward."
        basicField2.attributedPlaceholder = NSAttributedString(string: "Enter second Basic Reward.",
                                                            attributes: [NSAttributedStringKey.foregroundColor: blueColor])
        listOfBasicRewards1.sort()
//        listOfBasicRewards2.sort()
        listOfBasicRewards1.append("Enter Custom Reward Above")
//        listOfBasicRewards2.append("Enter Custom Reward Above")
        
        
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = listOfBasicRewards1[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:UIFont(name: "Avenir Next", size: 15.0)!,NSAttributedStringKey.foregroundColor:blueColor])
        return myTitle
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        let countRow : Int = listOfBasicRewards1.count
        
//        if pickerView == basicPicker2{
//            countRow = listOfBasicRewards2.count
//        }
        
        return countRow
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == basicPicker1{
            if basicReward1 == "Enter Custom Reward Above"{
                self.basicField1.becomeFirstResponder()
            }
            
            self.basicReward1 = self.listOfBasicRewards1[row]
            self.basicField1.text = basicReward1
            self.basicPicker1.isHidden = true
            self.basicField2.isHidden = false
            self.basicField2.isEnabled = true
        }
//        else if pickerView == basicPicker2{
//
//            basicReward2 = self.listOfBasicRewards2[row]
//
//            if basicReward2 == "Enter Custom Reward Above"{
//                self.basicField2.becomeFirstResponder()
//            }
//
//            self.basicField2.text = self.basicReward2
//            self.basicPicker2.isHidden = true
//        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.basicField1{
            
            self.basicField2.isHidden = true
            basicField2.isEnabled = false
            
            if basicReward1 != "Enter Custom Reward Above"{
                self.basicPicker1.isHidden = false
                textField.endEditing(true)
            }
            
        }
        if textField == self.basicField2{
            
            basicField2.isEnabled = true
            
//            if basicReward2 != "Enter Custom Reward Above" {
////                self.basicPicker2.isHidden = false
//                textField.endEditing(true)
//            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.basicField1 {
            basicReward1 = textField.text
        }
        if textField == self.basicField2{
            basicReward2 = textField.text
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.basicField1.endEditing(true)
        self.basicField2.endEditing(true)
    }
}


