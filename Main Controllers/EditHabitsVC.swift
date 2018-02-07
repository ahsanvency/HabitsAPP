//
//  EditHabitsVC.swift
//  Habits
//
//  Created by Ahsan Vency on 1/4/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit
import Firebase

class EditHabitsVC: UIViewController {
    
    
    @IBOutlet weak var whyTxt: UITextField!
    @IBOutlet weak var whenTxt: UITextField!
    @IBOutlet weak var whereTxt: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButton(_ sender: Any) {
        if Auth.auth().currentUser?.uid != nil {
            
            //checks to see if txtFeilds are empty
            let valid = validateTextFeilds()
            if valid == true{
                
                //current user
                guard let user = Auth.auth().currentUser else {
                    return
                }
                let uid = user.uid
                
                DataService.ds.REF_HABITS.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    let value = snapshot.value as? NSDictionary
                    
                    //getting habit key
                    guard let firstKey = value?.allKeys[0] else {
                        print("n")
                        return }

                    
                    let updates = ["When": self.whenTxt.text,
                                   "Where": self.whereTxt.text,
                                   "Why": self.whyTxt.text
                    ]

                    //Values to add to Habits list
                    DataService.ds.REF_HABITS.child(uid).child("\(firstKey)").updateChildValues(updates)
                    
                }) { (error) in
                    print(error.localizedDescription)
                }
                
                
                //Segue
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainScreenViewCID") as! MainScreenViewC
                self.present(newViewController, animated: true, completion: nil)
            } else {
                print("error")
            }
        }
    }
    
    
    func validateTextFeilds() -> Bool{
        if (whereTxt.text == nil || whenTxt.text == nil || whyTxt.text == nil){
            print("error")
            return false
        }
        return true
    }
}
