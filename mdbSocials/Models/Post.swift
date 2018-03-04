//
//  Post.swift
//  FirebaseDemoMaster
//
//  Created by Vidya Ravikumar on 9/22/17.
//  Copyright © 2017 Vidya Ravikumar. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import ObjectMapper

class Post: Mappable {
    
    var eventTitle: String?
    var eventDescribed: String?
    var imageUrl: String?
    var dateSelected: String?
    var posterId: String?
    var poster: String?
    var id: String?
    var image: UIImage?
    
    var interestedUsers: [String] = []
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id                          <- map["key"]
        eventTitle                 <- map["title"]
        eventDescribed             <- map["eventDescribed"]
        imageUrl                    <- map["imageUrl"]
        dateSelected                 <- map["dateSelected"]
        posterId                    <- map["posterId"]
        poster                          <- map["poster"]
        eventDescribed                 <- map["text"]
        interestedUsers                 <- map["num"]
        dateSelected                 <- map["timePicked"]
    }
    
//    init(id: String, postDict: [String:Any]?) {
//        self.id = id
//        if postDict != nil {
//            if let eventTitle = postDict!["title"] as? String {
//                self.eventTitle = eventTitle
//            }
//            if let eventDescribed = postDict!["eventDescribed"] as? String {
//                self.eventDescribed = eventDescribed
//            }
//            if let imageUrl = postDict!["imageUrl"] as? String {
//                self.imageUrl = imageUrl
//            }
//            if let dateSelected = postDict!["dateSelected"] as? String {
//                self.dateSelected = dateSelected
//            }
//            if let posterId = postDict!["posterId"] as? String {
//                self.posterId = posterId
//            }
//            if let poster = postDict!["poster"] as? String {
//                self.poster = poster
//            }
//            if let text = postDict!["text"] as? String {
//                self.eventDescribed = text
//            }
//            if let num = postDict!["num"] as? [String] {
//                self.interestedUsers = num
//            }
//            if let time = postDict!["timePicked"] as? String {
//                self.dateSelected = time
//        }
//
//        }
//    }
    
    init() {
        
    }
    
    func addInterestedUser(uid: String, withBlock: ()-> ()) {
        //update local array
        interestedUsers.append(uid)
        
        // update database
        let ref = Database.database().reference().child("Posts")
        let childUpdates = ["\(self.id!)/num": interestedUsers]
        ref.updateChildValues(childUpdates)
        withBlock()
        
    }
    
    func rmInterestedUser(id: String, withBlock: ()-> ()) {
        interestedUsers.popLast()
        let ref = Database.database().reference().child("Posts")
        let childUpdates = ["\(self.id!)/num": interestedUsers]
        ref.updateChildValues(childUpdates)
        withBlock()
        
        //        postObjs[indice].interestedUsers = postObjs[indice].interestedUsers.filter{$0 != "\(Auth.auth().currentUser!.uid)"}
        //        let ref = Database.database().reference().child("Posts")
        //        let childUpdates = ["\(Auth.auth().currentUser!.uid)/num":postObjs[indice].num!-1]
        //        ref.updateChildValues(childUpdates)
        //        interestLvl.text = "People Interested: \(String(info.num! - 1))"

//        interestedUsers.append(id)
//        
//        // update database
//        var ref = Database.database().reference().child("Posts")
//        let childUpdates = ["/\(self.id)/num": num!-1]
//        ref.updateChildValues(childUpdates)
    }
    
    
//    init() {
//        self.text = "This is a god dream"
//        self.imageUrl = "https://cmgajcmusic.files.wordpress.com/2016/06/kanye-west2.jpg"
//        self.id = "1"
//        self.poster = "Kanye West"
//    }
    
}

