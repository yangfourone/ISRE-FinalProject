//
//  LoginViewController.swift
//  ISRE-FinalProject
//
//  Created by 41 on 2018/12/12.
//  Copyright © 2018 41. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var register: UIButton!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var error_msg: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /** button style setting **/
        register.layer.cornerRadius = 5
        register.layer.borderColor = UIColor.black.cgColor
        register.layer.borderWidth = 2
        
        login.layer.cornerRadius = 5
        login.layer.borderColor = UIColor.black.cgColor
        login.layer.borderWidth = 2
        
        /** close keyboard when click anywhere **/
        self.hideKeyboardWhenTappedAround()
        
        /** default login **/
        error_msg.isHidden = true
        if UserDefaults.standard.bool(forKey: "isLogin") {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "vc") as! ViewController
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    @IBAction func register(_ sender: Any) {
    }
    @IBAction func login(_ sender: Any) {
        if account.text == "" && password.text == "" {
            error_msg.isHidden = true
            UserDefaults.standard.set(true, forKey: "isLogin")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "vc") as! ViewController
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            error_msg.isHidden = false
            error_msg.text = "ERROR!"
        }
    }
    
}

/** Close Keyboard **/
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
