//
//  DetailViewController.swift
//  mdbSocials
//
//  Created by Fang on 2/20/18.
//  Copyright © 2018 fang. All rights reserved.
//

import UIKit
import ChameleonFramework
import ObjectMapper
import SwiftyJSON
import MapKit
import Alamofire
import CoreLocation

class DetailViewController: UIViewController {
        
    // layout
    var eventName: UILabel!
    var posterName: UILabel!
    var details: UILabel!
    var interestButton: UIButton!
    var eventImage: UIImageView!
    var dateTime: UILabel!
    var interestLvl: UIButton!
    var loc: MKMapView!
    var getMeThere: UIButton!
    var weather: UILabel!
    
    // var info = Post();
    var postObjs: [Post] = []
    var indice: Int!
    
    var userRN: Users!

    // modal view
    var modalView: AKModalView!
    var interestedUsersView: InterestedUsersView!
    
    // navigation
    var cancel: UIButton!
    
    var latitude: Double!
    var longitude: Double!
    var status: String!
    var precip: String!
    var rainTime: Double!
    var locManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        locManager = CLLocationManager()
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        setupView()
        print("THIS IS")
        print(postObjs[indice].interestedUsers)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        while (CLLocationManager.authorizationStatus() != .authorizedWhenInUse) {
            locManager.requestWhenInUseAuthorization()
        }
        locManager.startUpdatingLocation()
    }
    
    
    @objc func backBack() {
        self.dismiss(animated: true, completion: {})
    }
    
    @objc func interestShown() {
        if interestButton.backgroundColor == Constants.appRed {
            noToYes()
            interestButton.backgroundColor = Constants.appGreen
            interestButton.setTitle("i'm going ", for: .normal)
        } else {
            yesToNo()
            interestButton.backgroundColor = Constants.appRed
            interestButton.setTitle("I'M INTERESTED", for: .normal)
        }
    }
    
    func noToYes() {
        // add to interestedUsers
        postObjs[indice].addInterestedUser(uid: FirebaseHelper.currUserID(), withBlock: {
            interestLvl.setTitle("People Interested: \(String(postObjs[indice].interestedUsers.count))", for: .normal)
            })
        userRN.addInterestedEvent(id: postObjs[indice].id!)
//        let json = JSON(FirebaseHelper.currUser())
////        var result = json.dictionaryObject
////        {
//            print("I came here")
//            if let currUser = Users(JSON: json) {
////                print("I came here")
//                currUser.addInterestedEvent(id: postObjs[indice].id!)
//            }
////        }
        
        
//            text = "People Interested: \(String(postObjs[indice].interestedUsers.count))"

    }
    
    func yesToNo() {
        postObjs[indice].rmInterestedUser(id: FirebaseHelper.currUserID(), withBlock: {
            interestLvl.setTitle("People Interested: \(String(postObjs[indice].interestedUsers.count))", for: .normal)
    })
        userRN.rmInterestedEvent(id: postObjs[indice].id!)

    }
    
    @objc func openInterestedUsersModalView() {
        interestedUsersView = InterestedUsersView(frame: CGRect(x: 15, y: 70, width: view.frame.width - 30, height: view.frame.height - 75 - (110)))
        var listToShow: [String] = []
        print("beginning request")
        for i in postObjs[indice].interestedUsers {
            FirebaseHelper.getUserName(id: i).then{ username -> Void in
                listToShow += [username]
                print("got username")
                print(username)
                
                
                //                var usernametoreturn = "\(username)\n"
                //                listToShow = listToShow + usernametoreturn
                //                self.interestedUsersView.names.text = self.interestedUsersView.names.text! + "\(username)\n"
                //                self.interestedUsersView.names.text = listToShow
                //                self.modalView = AKModalView(view: self.interestedUsersView)
                //                self.modalView.dismissAnimation = .FadeOut
                //                self.view.addSubview(self.modalView)
                //                self.modalView.show()
                
                } .then{ _ -> Void in
                    print("list to show is")
                    print(listToShow)
                    self.interestedUsersView.listOfNames = listToShow
                    print("updated list of names")
                    DispatchQueue.main.async {
                        self.interestedUsersView.tableView.reloadData()
                        print("reloaded data")

                    }
            }
        }
        //        print(listToShow)
        //        interestedUsersView.names.text = listToShow
        
        print(interestedUsersView.listOfNames)
        modalView = AKModalView(view: interestedUsersView)
        modalView.dismissAnimation = .FadeOut
        view.addSubview(modalView)
        //        navigationController?.view.addSubview(modalView)
        modalView.show()
    }
    
        func addAnnotationToMap(){
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: 37.864263, longitude:-122.270462)
//            annotation.coordinate = CLLocationCoordinate2D(latitude: viewController.post.latitude!, longitude: viewController.post.longitude!)
            loc.addAnnotation(annotation)
            loc.setRegion(MKCoordinateRegionMake(annotation.coordinate, MKCoordinateSpanMake(0.001, 0.001)), animated: true)
        }
    
    @objc func openAMaps() {
        let urlString = "http://maps.apple.com/?saddr=&daddr=\(37.8663),\(-122.261733)"
        let url = URL(string: urlString)
        UIApplication.shared.open(url!)
//        let urlString = "http://maps.apple.com/?saddr=&daddr=\(viewController.post.latitude!),\(viewController.post.longitude!)"
        
    }
}
