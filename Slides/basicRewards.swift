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
    @IBOutlet weak var basicPicker2: UIPickerView!
    
    var listOfBasicRewards1 = ["Chocolate", "Candy", "Sweet Drink", "Posting a Selfie", "Watch a Youtube Video", "Cheese and Crackers", "Light Candles"]
    
    var listOfBasicRewards2 = ["Chocolate", "Candy", "Sweet Drink", "Posting a Selfie", "Watch a Youtube Video", "Cheese and Crackers", "Light Candles"]
    
    var basicReward1: String?
    var basicReward2: String?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        basicField1.delegate = self
        basicField2.delegate = self
        
        basicPicker1.delegate = self
        basicPicker1.dataSource = self
        basicPicker2.delegate = self
        basicPicker2.dataSource = self
        
        basicField1.text = "Tap to pick a basic reward."
        basicField2.text = "Tap to pick a basic reward."
        listOfBasicRewards1.sort()
        listOfBasicRewards2.sort()
        listOfBasicRewards1.append("Enter Custom Reward Above")
        listOfBasicRewards2.append("Enter Custom Reward Above")
        
        let layer : CAGradientLayer = CAGradientLayer()
    //    layer.frame.size = self.frame.size
        
        let color0 = UIColor(red:13/255, green:76/255, blue:153/255, alpha:0.85).cgColor
        let color1 = UIColor(red:99/255, green:42/255, blue: 91/255, alpha:0.76).cgColor
        let color2 = UIColor(red:186/255, green:7/255, blue: 29/255, alpha:0.71).cgColor
        let color3 = UIColor(red:218/255, green:128/255, blue:125/255, alpha:0.86).cgColor
        let color4 = UIColor(red:247/255, green:240/255, blue: 215/255, alpha:100).cgColor
        layer.colors = [color0,color1,color2,color3,color4]
        self.layer.insertSublayer(layer, at: 0)
        
        layer.cornerRadius = 5.0
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
        var countRow : Int = listOfBasicRewards1.count
        
        if pickerView == basicPicker2{
            countRow = listOfBasicRewards2.count
        }
        
        return countRow
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == basicPicker1{
            let reward = listOfBasicRewards1[row]
            return reward
        }else if pickerView == basicPicker2{
            let reward = listOfBasicRewards2[row]
            return reward
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == basicPicker1{
            
            basicReward1 = self.listOfBasicRewards1[row]
            
            if basicReward1 == "Enter Custom Reward Above"{
                self.basicField1.becomeFirstResponder()
            }
            self.basicField1.text = basicReward1
            self.basicPicker1.isHidden = true
            self.basicField2.isHidden = false
            self.basicField2.isEnabled = true
            
        }
        else if pickerView == basicPicker2{
            
            basicReward2 = self.listOfBasicRewards2[row]
            
            if basicReward2 == "Enter Custom Reward Above"{
                self.basicField2.becomeFirstResponder()
            }
            self.basicField2.text = basicReward2
            self.basicPicker2.isHidden = true
        }
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
            
            basicField1.isEnabled = true
            
            if basicReward2 != "Enter Custom Reward Above" {
                self.basicPicker2.isHidden = false
                textField.endEditing(true)
            }
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


