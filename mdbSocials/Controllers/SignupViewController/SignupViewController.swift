//
//  SignupViewController.swift
//  mdbSocials
//
//  Created by Fang on 2/20/18.
//  Copyright © 2018 fang. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    
    // navigation
    var cancel: UIButton!
    
    // UI Elements
    var imageView: UIImageView!
    var uLabel: UILabel!
    var pLabel: UILabel!
    var nLabel: UILabel!
    var iLabel: UILabel!
    
    // Inut Fields
    var addPP: UIButton!
    let picker = UIImagePickerController()
    var ppDisplay: UIImageView!
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    var repeatTextField: UITextField!
    var nameTextField: UITextField!
    var unameTextField: UITextField!

    //buttons
    var signupButton: UIButton!

    // saved parameters
    var userDict = [String: Any]();
    
    // user model
    var madeUser = Users()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*************************************************************************************************/
    /************************************ SIGN UP PRESSED FN *****************************************/
    /*************************************************************************************************/
    @objc func signUpPressed() {
        //TODO: Implement this method with Firebase!
        
        if nameTextField.text! == "" {
            Utils.throwError(info: "Please key in your name", vc: self)
        } else if emailTextField.text! == "" {
            Utils.throwError(info: "Please enter your email", vc: self)
        } else if unameTextField.text! == "" {
            Utils.throwError(info: "Please key in a username", vc: self)
        } else if passwordTextField.text! == "" {
            Utils.throwError(info: "Please key in a password", vc: self)
        } else if repeatTextField.text! == "" {
            Utils.throwError(info: "Please confirm your password", vc: self)
        } else if (passwordTextField.text! != repeatTextField.text!) {
            Utils.throwError(info: "Passwords don't match!", vc: self)
        } else {
            let email = emailTextField.text!
            let password = passwordTextField.text!
            
            userDict["name"] = nameTextField.text!
            userDict["username"] = unameTextField.text!
            
            
            FirebaseHelper.makeUserPicOptional(userModel: madeUser, email: email, password: password, dictOfInfo: userDict, successAction: { self.performSegue(withIdentifier: "signUpToFeed", sender: self)}, failureAction: {Utils.throwError(info: "Please make sure you entered a valid email and your password is longer than 6 characters", vc: self)}).then{(userId) in FirebaseHelper.putImageInStorage(img: self.ppDisplay.image, userId: userId)}
        }
    }
    
    @objc func toLogin() {
        self.dismiss(animated: true, completion: {})
    }
    
    @objc func pickPP(sender: UIButton!) {
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
}
