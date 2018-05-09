//
//  habitCarouselSelector.swift
//  Habits
//
//  Created by Ahsan Vency on 3/31/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit

class habitCarouselSelector: iCarousel {

    let customWidth:CGFloat = 175
    let customHeight:CGFloat = 225
    var habits: [Habit]!
}

extension habitCarouselSelector: iCarouselDataSource{
    func numberOfItems(in carousel: iCarousel) -> Int {
        return habits.count
    }
}

extension habitCarouselSelector: iCarouselDelegate{
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: customWidth, height: customHeight))
        
        let habitImageView = UIImageView(image: habits[index].habitPic)
        habitImageView.frame = CGRect(x: 12.5, y: 0, width: 150, height: 175)
        habitImageView.contentMode = .scaleAspectFit
        view.addSubview(habitImageView)
        
        let habitNameLabel = UILabel()
        habitNameLabel.frame = CGRect(x: 12.5, y: 195, width: 150, height: 30)
        habitNameLabel.text = habits[index].habitName
        habitNameLabel.textColor = .white
        habitNameLabel.textAlignment = .center
        habitNameLabel.font = UIFont(name: "D-DIN", size: 26)
        habitNameLabel.adjustsFontSizeToFitWidth = true
        habitNameLabel.minimumScaleFactor = 0.2
        view.addSubview(habitNameLabel)
        
        return view
    }
    
    
    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == iCarouselOption.spacing {
            return value * 1.8
        }
        return value * 1.1
    }
    
//    func carousel(_ carousel: iCarousel?, itemTransformForOffset offset: CGFloat, baseTransform transform: CATransform3D) -> CATransform3D {
//        let offsetFactor : CGFloat = self.carousel(carousel: iCarousel, valueForOption: iCarouselOption.spacing, withDefault: 1.0) * carousel?.itemWidth
//        transform = CATransform3DTranslate(transform, offset * offsetFactor, 0, 0)
//        return transform
//    }
    

}
