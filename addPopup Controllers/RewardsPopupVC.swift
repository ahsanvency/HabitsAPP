//
//  ViewController.swift
//  Habits
//
//  Created by Ahsan Vency on 1/29/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit

class rewardsPopupVC: UIViewController, UITextViewDelegate {

    var basicStr: String = ""
    var intStr: String = ""
    var advStr: String = ""
    
    var weekArray = [Int]()
    var habitName: String?
    var whyLblText: String = ""
    var whenLblText:String = ""
    var whereLblText:String = ""
    var currentText:String = ""

    @IBOutlet weak var basicText: UITextView!
    @IBOutlet weak var intText: UITextView!
    @IBOutlet weak var advText: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        basicText.text = basicStr
        intText.text = intStr
        advText.text = advStr
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveBtn(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let backView = storyBoard.instantiateViewController(withIdentifier: "NewHabitVCID") as! NewHabitVC
        backView.whereLblText = whereLblText
        backView.weekArray = weekArray
        backView.whyLblText = whyLblText
        backView.whenLblText = whenLblText
        backView.basicStr = basicText.text
        backView.intStr = intText.text
        backView.advStr = advText.text
        backView.currentText = currentText
        self.present(backView, animated: true) {
        }
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView == self.basicText {
            self.basicText.becomeFirstResponder()
            scrollDown(y: 583)
        }else if textView == self.intText {
            self.intText.becomeFirstResponder()
            scrollDown(y: 283)
        }else{
            self.advText.becomeFirstResponder()
            scrollDown(y: -17)
        }
    }
    
//    func textViewDidChange(_ textView: UITextView){
//        scrollDown()
//    }
    
    func scrollDown(y: CGFloat){
    DispatchQueue.main.async(execute: {
    self.scrollView.setContentOffset(CGPoint(x: 0,y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height - y), animated: true)
    })
    }
}
