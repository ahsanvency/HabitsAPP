//
//  whereAddPopupVC.swift
//  Habits
//
//  Created by Ahsan Vency on 1/21/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit

class whereAddPopupVC: UIViewController {
    
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
    
    @IBOutlet weak var whereText: fancyField!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var screenTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myGradient = UIImage(named: "textWherePopup.png")
        screenTitle.textColor = UIColor(patternImage: myGradient ?? UIImage())
        
        questionLabel.text = "Where is a consistent location you can \(String(describing: habitName!))"
        self.hideKeyboardWhenTappedAround()
        //habitTxt.text = habitName
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButton(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let whereView = storyBoard.instantiateViewController(withIdentifier: "NewHabitVCID") as! NewHabitVC
        whereView.whereLblText = whereText.text!
        whereView.weekArray = weekArray
        whereView.whyLblText = whyLblText!
        whereView.whenLblText = whenLblText!
        whereView.basicStr = basicStr!
        whereView.intStr = intStr!
        whereView.advStr = advStr!
        whereView.currentText = currentText!
        whereView.editButtonPressed = 1
        self.present(whereView,animated: true, completion: nil)
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true){
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let whereView = storyBoard.instantiateViewController(withIdentifier: "NewHabitVCID") as! NewHabitVC
            whereView.weekArray = self.weekArray
            whereView.whyLblText = self.whyLblText!
            whereView.whenLblText = self.whenLblText!
            whereView.basicStr = self.basicStr!
            whereView.intStr = self.intStr!
            whereView.advStr = self.advStr!
            whereView.currentText = self.currentText!
            whereView.editButtonPressed = 1
        }
    }
    
    
}
