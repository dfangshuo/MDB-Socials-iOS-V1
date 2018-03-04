//
//  LoginViewController.swift
//  mdbSocials
//
//  Created by Fang on 2/20/18.
//  Copyright © 2018 fang. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // UI Elements
    var imageView: UIImageView!
    var noAcc: UILabel!
    var uLabel: UILabel!
    var pLabel: UILabel!
    
    // Email & Password
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    
    // Login and Signup Buttons
    var login: UIButton!
    var signup: UIButton!
    
    // user model
    var loginUser: Users!;

    // checks if the user is logged in or not
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if FirebaseHelper.currUser() != nil {
            self.performSegue(withIdentifier: "toFeed", sender: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImage()
        setupTextFields()
        setupButtons()
    }
    
    /*************************************************************************************************/
    /************************************ BUTTON FUNCTIONS *******************************************/
    /*************************************************************************************************/
    
    @objc func loginPressed() {
        if emailTextField.text! == "" {
            Utils.throwError(info: "email not found!", vc: self)
        } else if passwordTextField.text! == "" {
            Utils.throwError(info: "please enter a password!", vc: self)
        } else {
            UserAuthHelper.logIn(email: emailTextField.text!, password:passwordTextField.text!, successAction: {self.performSegue(withIdentifier: "toFeed", sender: self)}, fAction: {Utils.throwError(info: "Invalid Username/Password", vc: self)})
            emailTextField.text = ""
            passwordTextField.text = ""
        }
    }
    
    @objc func toSignUp() {
        self.performSegue(withIdentifier: "toSignUp", sender: self)
    }
}
