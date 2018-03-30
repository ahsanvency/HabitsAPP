//
//  habitPicker.swift
//  Habits
//
//  Created by Ahsan Vency on 3/29/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit

class habitSelector: UIPickerView {
    
    var habits: [Habit]!
    let customWidth:CGFloat = 200
    let customHeight:CGFloat = 200
}

extension habitSelector: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        pickerView.subviews.forEach({
            $0.isHidden = $0.frame.height < 1.0
        })
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return habits.count
    }
}

extension habitSelector: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return customHeight
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return customWidth
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: customWidth, height: customHeight))
        
        let habitImageView = UIImageView(image: habits[row].habitPic)
        habitImageView.frame = CGRect(x: 12.5, y: 25, width: 175, height: 175)
        view.addSubview(habitImageView)
        
        let habitNameLabel = UILabel()
        habitNameLabel.frame = CGRect(x: 12.5, y: 210, width: 175, height: 30)
        habitNameLabel.text = habits[row].habitName
        habitNameLabel.textColor = .white
        habitNameLabel.textAlignment = .center
        habitNameLabel.font = UIFont(name: "D-DIN-Bold", size: 24)
        habitNameLabel.adjustsFontSizeToFitWidth = true
        habitNameLabel.minimumScaleFactor = 0.2
        view.addSubview(habitNameLabel)
        
//        let topLabel = UILabel(frame: CGRect(x: 0, y: 10, width: customWidth, height: 15))
//        topLabel.text = habits[row].habitName
//        topLabel.textColor = .white
//        topLabel.textAlignment = .center
//        topLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.thin)
//        view.addSubview(topLabel)
        
        view.transform = CGAffineTransform(rotationAngle: (90 * (.pi/180)))
        return view
    }
    
}
