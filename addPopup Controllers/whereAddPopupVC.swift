//
//  whereAddPopupVC.swift
//  Habits
//
//  Created by Ahsan Vency on 1/21/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit

class whereAddPopupVC: UIViewController {
    
    var weekArray = [Int]()
    var habitName: String?
    var whyLblText: String = ""
    var whenLblText:String = ""
    var whereLblText:String = ""
    var currentText:String = ""

    var basicStr: String = ""
    var intStr: String = ""
    var advStr: String = ""
    
    @IBOutlet weak var whereText: fancyField!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var screenTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var myGradient = UIImage(named: "Rectangle1x.png")
        screenTitle.textColor = UIColor(patternImage: myGradient ?? UIImage())
        
        questionLabel.text = "Where is a consistent location you can \(String(describing: habitName!))"
        
        //habitTxt.text = habitName
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButton(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let whereView = storyBoard.instantiateViewController(withIdentifier: "NewHabitVCID") as! NewHabitVC
        whereView.whereLblText = whereText.text!
        whereView.weekArray = weekArray
        whereView.whyLblText = whyLblText
        whereView.whenLblText = whenLblText
        whereView.basicStr = basicStr
        whereView.intStr = intStr
        whereView.advStr = advStr
        whereView.currentText = currentText
        whereView.editButtonPressed = 1
        self.present(whereView,animated: true, completion: nil)
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true){
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let whereView = storyBoard.instantiateViewController(withIdentifier: "NewHabitVCID") as! NewHabitVC
            whereView.editButtonPressed = 0
        }
    }
    
    
}
