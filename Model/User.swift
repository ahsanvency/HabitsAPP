//
//  User.swift
//  Habits
//
//  Created by Ahsan Vency on 1/11/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import Foundation
import Firebase
import UIKit


class User{
    private var _userName: String!
    private var _habits: Array<Any>!

    init(userName: String, habits: Array<Any> = []){
        _userName = userName;
        _habits = habits;
    }
    
    var name: String{
        get{
            return _userName;
        }
        set{
            _userName = newValue;
        }
    }
    
    var habits: Array<Any>{
        get{
            return _habits
        }
        set{
            _habits = newValue
        }
    }
    

    
}
