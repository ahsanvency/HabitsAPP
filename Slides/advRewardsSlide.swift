//
//  Slide.swift
//  Habits
//
//  Created by Ahsan Vency on 3/29/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit

class advRewardsSlide: UIView, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var advField: UITextField!
    @IBOutlet weak var advPicker: UIPickerView!
    
    
    
    var listOfAdvRewards = ["New Tatto or Piercing", "Pedicure", "Take a Day Off", "Go Shopping", "Party", "Go Camping", "Weekend Trip"]
    
    var advReward: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        advField.delegate = self
        
        advPicker.delegate = self
        advPicker.dataSource = self
        
        advField.text = "Tap to pick an advanced reward."
        listOfAdvRewards.sort()
        listOfAdvRewards.append("Enter Custom Reward Above.")
        
        let layer : CAGradientLayer = CAGradientLayer()
  //      layer.frame.size = self.frame.size
        
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
        let titleData = listOfAdvRewards[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:UIFont(name: "Avenir Next", size: 15.0)!,NSAttributedStringKey.foregroundColor:blueColor])
        return myTitle
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return listOfAdvRewards.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        //The user cannot edit the components anymore
        self.advField.endEditing(true)
        //This is the value that was selected by the picker
        return listOfAdvRewards[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.advField.endEditing(true)
        advReward = self.listOfAdvRewards[row]
        
        if advReward == "Enter Custom Reward Above."{
            self.advField.becomeFirstResponder()
        }
        self.advField.text = advReward!
        self.advPicker.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.advField {
            
            if advReward != "Enter Custom Reward Above."{
                self.advPicker.isHidden = false
                textField.endEditing(true)
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        advReward = textField.text
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.advField.endEditing(true)
        
    }
}




