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
import LocationPicker
import MapKit

class NewSocialViewController: UIViewController,UITextViewDelegate {
    
    // event entry parameters
    var eventName: UITextField!
    var descrip: UITextView!
    var makeEventButton: UIButton!
    var addImage: UIButton!
    var takePicture: UIButton!
    var datePicker: UIDatePicker!
    var locPicker: UIButton!

    // navigation
    var cancel: UIButton!

    // event storage parameters
    var eventCalled: String!
    var dateSelected: String!
    var eventDescribed: String!
    
    // temp date storage
    var tempDate: String!
    var eventImageView: UIImageView!
    let picker = UIImagePickerController()
    var longLat: CLLocationCoordinate2D!
    var lat: Double!
    var long: Double!
    
    var postingUser: Users!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpEventView()
    }
    
    @objc func eventMade() {
        if (eventName.text! != "") {
             eventCalled = eventName.text!
            
            // format description data
            if descrip.text == "What in the world is this???" {
                eventDescribed = ""
            } else {
                eventDescribed = descrip.text!
            }
            
            if tempDate == nil {
                Utils.throwError(info: "Is this really the time you want?", vc: self)
            } else {
                dateSelected  = tempDate!
                FirebaseHelper.makePostPicOptional(title: self.eventCalled, postText: self.eventDescribed, poster: self.postingUser.name!, posterId: self.postingUser.id!, num: [FirebaseHelper.currUserID()], timePicked: self.dateSelected, img: eventImageView.image)
            }
        } else {
            Utils.throwError(info: "Please name this event", vc: self)
        }
        self.dismiss(animated: true, completion: {})
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        
        // Apply date format
        tempDate = dateFormatter.string(from: sender.date)
        
        print("Selected value \(tempDate!)")
    }

    @objc func goBack() {
        print("Cancelled")
        self.dismiss(animated: true, completion: {})
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == Constants.appTxt {
            textView.text = nil
            textView.textColor = HexColor("000000")!
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "What in the world is this???"
            textView.font = textView.font?.withSize(20)
            textView.textColor = Constants.appTxt
        }
    }
    
    @objc func pickImage(sender: UIButton!) {
            picker.delegate = self
            picker.allowsEditing = false
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
    
    @objc func takePic() {
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .camera
        self.present(picker, animated: true, completion: nil)
    }
    
    @objc func pickLoc() {
        
        let locationPicker = LocationPickerViewController()
        locationPicker.showCurrentLocationButton = true // default: true
        locationPicker.currentLocationButtonBackground = Constants.appColor
        locationPicker.mapType = .standard // default: .Hybrid
        locationPicker.searchBarPlaceholder = "Where the party at" // default: "Search or enter an address"
        locationPicker.resultRegionDistance = 500 // default: 600
        
        locationPicker.completion = { location in
            self.longLat = location?.coordinate
            self.long = self.longLat.longitude
            self.lat = self.longLat.latitude
            let newTitle = String(self.long) + ", " + String(self.lat)
            self.locPicker.setTitle(newTitle, for: .normal)

            print(self.longLat)

        }
        
        self.present(locationPicker, animated: true) {
            print("Selecting location")
        }
    }
}
