//
//  habitInfoVC.swift
//  Habits
//
//  Created by Ahsan Vency on 3/29/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit

class habitInfoVC: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var habitPic: UIImageView!
    
    @IBOutlet weak var scrollInfo: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var chosenHabit: Habit!
    var whySlide: whySlide!
    var whereSlide: whereSlide!
    var whenSlide: whenSlide!
    var basicRewardsSlide: basicRewardsSlide!
    var intRewardsSlide: intRewardsSlide!
    var advRewardsSlide: advRewardsSlide!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Change this line of code
        habitPic.image = UIImage(named: chosenHabit.habitName)
        //habitPic.image = UIImage(named: "Running")
        scrollInfo.delegate = self
        let Slides:[UIView] = createSlides()
        setupscrollInfo(Slides: Slides)
        pageControl.numberOfPages = Slides.count
        pageControl.currentPage = 0
        view.bringSubview(toFront: pageControl)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func createSlides() -> [UIView]{
        whySlide = Bundle.main.loadNibNamed("whySlide", owner: self, options: nil)!.first as! whySlide
        whySlide.intrinsicLabel.text = "Did you know intrinsic reasons like \(chosenHabit.intrinsicReason) help you succeed?"
        whySlide.questionLabel.text = "Why do you want to start \(chosenHabit.habitName)?"
        
        whereSlide = Bundle.main.loadNibNamed("whereSlide", owner: self, options: nil)!.first as! whereSlide
        whereSlide.questionLabel.text = "Where is a consistent location you can \(chosenHabit.habitVerb)?"
        
        whenSlide = Bundle.main.loadNibNamed("whenSlide", owner: self, options: nil)!.first as! whenSlide
        whenSlide.questionLabel.text = "When can you consistently \(chosenHabit.habitVerb)?"
        
        basicRewardsSlide = Bundle.main.loadNibNamed("basicRewardsSlide", owner: self, options: nil)!.first as! basicRewardsSlide
        
        intRewardsSlide = Bundle.main.loadNibNamed("intRewardsSlide", owner: self, options: nil)!.first as! intRewardsSlide
        
        advRewardsSlide = Bundle.main.loadNibNamed("advRewardsSlide", owner: self, options: nil)!.first as! advRewardsSlide
        
        return [whySlide!, whereSlide, whenSlide, basicRewardsSlide, intRewardsSlide, advRewardsSlide]
    }
    
    func setupscrollInfo(Slides:[UIView]){
        scrollInfo.frame = CGRect(x: 0, y: 0, width: scrollInfo.frame.width, height: view.frame.height)
        scrollInfo.contentSize = CGSize(width: scrollInfo.frame.width * CGFloat(Slides.count), height: view.frame.height)
        scrollInfo.isPagingEnabled = true
        
        for i in 0..<Slides.count{
            Slides[i].frame = CGRect(x: scrollInfo.frame.width * CGFloat(i) , y: 0, width: scrollInfo.frame.width, height: view.frame.height)
            scrollInfo.addSubview(Slides[i])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/scrollInfo.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
    
    @IBAction func saveHabit(_ sender: Any){
        print(whySlide.whyField.text!)
        print(whereSlide.whereField.text!)
        
    }
    
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= (keyboardSize.height - 125)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += (keyboardSize.height - 125)
            }
        }
    }
    
}
