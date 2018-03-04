//
//  NewSocialViewController.swift
//  mdbSocials
//
//  Created by Fang on 2/20/18.
//  Copyright © 2018 fang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import ChameleonFramework

extension NewSocialViewController {
    
    func setUpView() {
        
        eventName = UITextField(frame: CGRect(x: 40, y: 70, width: view.frame.width - 20, height: 40))
        eventName.placeholder = "New Event"
        eventName.clipsToBounds = true
        eventName.adjustsFontSizeToFitWidth = true
        eventName.font = eventName.font!.withSize(38)
        view.addSubview(eventName)
        
        descrip = UITextView(frame: CGRect(x: 8, y: 510, width: self.view.frame.width-16, height: 90))
        descrip.delegate = self
        descrip.becomeFirstResponder()
        descrip.selectedTextRange = descrip.textRange(from: descrip.beginningOfDocument, to: descrip.beginningOfDocument)
        descrip.layoutIfNeeded()
        descrip.layer.borderColor = Constants.appColor.cgColor
        descrip.layer.borderWidth = 1.5
        descrip.layer.cornerRadius = 10
        descrip.layer.masksToBounds = true
        descrip.clipsToBounds = true
        descrip.textColor = HexColor("000000")!
        view.addSubview(descrip)
        
        datePicker = UIDatePicker(frame: CGRect(x: 10, y: 350,  width: UIScreen.main.bounds.width - 16, height: 115))
        datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = HexColor("FFFFFF")!
        
        // Add an event to call onDidChangeDate function when value is changed.
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        // Add DataPicker to the view
        self.view.addSubview(datePicker)
        
        locPicker = UIButton(frame: CGRect(x: 10, y: 465, width: UIScreen.main.bounds.width - 20, height: 35))
        locPicker.layoutIfNeeded()
        locPicker.setTitle("Where is this?", for: .normal)
        locPicker.layer.cornerRadius = 10
        locPicker.backgroundColor = Constants.appTxt
        locPicker.addTarget(self, action: #selector(pickLoc), for: .touchUpInside)
        view.addSubview(locPicker)
        
        makeEventButton = UIButton(frame: CGRect(x: 10, y: 0.8 * UIScreen.main.bounds.height+25, width: UIScreen.main.bounds.width - 20, height: 45))
        makeEventButton.layoutIfNeeded()
        makeEventButton.setTitle("Make Event", for: .normal)
        makeEventButton.layer.cornerRadius = 10
        makeEventButton.addTarget(self, action: #selector(eventMade), for: .touchUpInside)
        makeEventButton.backgroundColor = Constants.appColor
        view.addSubview(makeEventButton)
        
        cancel = UIButton(frame:CGRect(x: (view.frame.width - 125)/2, y: 675, width: 125, height: 30))
        cancel.setTitleColor(Constants.appColor, for: .normal)
        cancel.setTitle("back", for: .normal)
        cancel.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        view.addSubview(cancel)

    }
    
    func setUpEventView() {
        eventImageView = UIImageView(frame: CGRect(x: 40, y: 70, width: UIScreen.main.bounds.width - 85, height: UIScreen.main.bounds.width - 85))
        eventImageView.clipsToBounds = true
        view.addSubview(eventImageView)
        
        takePicture = UIButton(frame: CGRect(x:(view.frame.width-75)/2 - 45, y: 170, width: 75, height: 75))
        takePicture.setTitle("Camera", for: .normal)
        takePicture.clipsToBounds = true
        takePicture.addTarget(self, action: #selector(takePic), for: .touchUpInside)
        takePicture.layer.cornerRadius = 10
        takePicture.backgroundColor = Constants.appColor
        view.addSubview(takePicture)
        
        addImage = UIButton(frame: CGRect(x:(view.frame.width-75)/2 + 45, y: 170, width: 75, height: 75))
        addImage.setTitle("Roll", for: .normal)
        addImage.clipsToBounds = true
        addImage.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
        addImage.layer.cornerRadius = 10
        addImage.backgroundColor = Constants.appTxt
        view.addSubview(addImage)
        //        view.bringSubview(toFront: addImage)
    }
}

