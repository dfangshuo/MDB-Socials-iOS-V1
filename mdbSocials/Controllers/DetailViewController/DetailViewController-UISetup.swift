//
//  DetailViewController.swift
//  mdbSocials
//
//  Created by Fang on 2/20/18.
//  Copyright © 2018 fang. All rights reserved.
//

import UIKit
import ChameleonFramework
import MapKit

extension DetailViewController {
    
    func setupView() {
        eventName = UILabel(frame: CGRect(x: 13, y: 60, width: view.frame.width - 20, height: 40))
        eventName.text = postObjs[indice].eventTitle!
        eventName.clipsToBounds = true
        eventName.adjustsFontSizeToFitWidth = true
        eventName.font = eventName.font!.withSize(38)
        view.addSubview(eventName)
        
        posterName = UILabel(frame: CGRect(x: 13, y: 100, width: view.frame.width - 20, height: 40))
        posterName.text = "by \(postObjs[indice].poster!)"
        posterName.clipsToBounds = true
        posterName.adjustsFontSizeToFitWidth = true
        posterName.font = posterName.font!.withSize(25)
        posterName.textColor = HexColor("696969")
        view.addSubview(posterName)
        
        eventImage = UIImageView(frame: CGRect(x: 13, y: 140, width: UIScreen.main.bounds.width - 25, height: UIScreen.main.bounds.width - 170))
        eventImage.image = #imageLiteral(resourceName: "MDB Cover")
        eventImage.layer.cornerRadius = 10
        eventImage.clipsToBounds = true
        //FirebaseHelper.downloadPic(imageName:postObjs[indice].id!)
//        promiseKeep()
        //FirebaseHelper.downloadPic(imageName:postObjs[indice].id!, withBlock: { img in
          //  self.eventImage.image = img
        //})
        FirebaseHelper.downloadPic(withURL:postObjs[indice].imageUrl!).then { img in
            self.eventImage.image = img
        }
        view.addSubview(eventImage)
        
        weather = UILabel(frame: CGRect(x: 79, y: 515, width: view.frame.width-16, height: 20))
        weather.clipsToBounds = true
        weather.textColor = HexColor("000000")
        weather.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(weather)
        
        //x: 101
        dateTime = UILabel(frame: CGRect(x: 13, y: 425, width: view.frame.width-16, height: 20))
        dateTime.text = postObjs[indice].dateSelected!
        dateTime.clipsToBounds = true
        dateTime.textColor = HexColor("000000")
        dateTime.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(dateTime)
        //x: 125
        interestLvl = UIButton(frame: CGRect(x: 13, y: 453, width: (view.frame.width-118)/2, height: 20))
        interestLvl.setTitle("People Interested: \(postObjs[indice].interestedUsers.count)" , for: .normal)
        interestLvl.titleLabel!.font = UIFont.boldSystemFont(ofSize: 15)
        interestLvl.addTarget(self, action: #selector(openInterestedUsersModalView), for: .touchUpInside)
        interestLvl.setTitleColor(HexColor("696969"), for: .normal)
        view.addSubview(interestLvl)
        
        loc = MKMapView(frame:CGRect(x: view.frame.width/2+21, y: 415, width: 175, height: 70))
        loc.layer.cornerRadius = 10
        loc.mapType = .standard
        loc.clipsToBounds = true
        view.addSubview(loc)
        addAnnotationToMap()
        
        details = UILabel(frame: CGRect(x: 8, y: 495, width: self.view.frame.width-16, height: 65))
        details.layoutIfNeeded()
        details.text = postObjs[indice].eventDescribed!
        details.layer.borderColor = Constants.appColor.cgColor
        details.layer.borderWidth = 1.5
        details.layer.cornerRadius = 10
        details.layer.masksToBounds = true
        details.clipsToBounds = true
        details.textColor = HexColor("696969")
        view.addSubview(details)
        
        interestButton = UIButton(frame: CGRect(x: 10, y: 0.8 * UIScreen.main.bounds.height-18, width: UIScreen.main.bounds.width - 20, height: 45))
        interestButton.layoutIfNeeded()
        
        if postObjs[indice].interestedUsers.contains(FirebaseHelper.currUserID()) {
            interestButton.backgroundColor = Constants.appGreen
            interestButton.setTitle("i'm going ", for: .normal)
        } else {
            interestButton.setTitle("I'M INTERESTED", for: .normal)
            interestButton.backgroundColor = Constants.appRed
        }
        
        interestButton.addTarget(self, action: #selector(interestShown), for: .touchUpInside)
        interestButton.layer.cornerRadius = 10
        view.addSubview(interestButton)
        
        getMeThere = UIButton(frame: CGRect(x: 10, y: 0.8 * UIScreen.main.bounds.height+33, width: UIScreen.main.bounds.width - 20, height: 45))
        getMeThere.addTarget(self, action: #selector(openAMaps), for: .touchUpInside)
        getMeThere.setTitle("GET ME THERE G", for: .normal)
        getMeThere.backgroundColor = Constants.appColor
        getMeThere.layer.cornerRadius = 10
        view.addSubview(getMeThere)
        
        cancel = UIButton(frame:CGRect(x: (view.frame.width - 125)/2, y: 675, width: 125, height: 30))
        cancel.setTitleColor(Constants.appColor, for: .normal)
        cancel.setTitle("back", for: .normal)
        cancel.addTarget(self, action: #selector(backBack), for: .touchUpInside)
        view.addSubview(cancel)
    }
}

