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
    }
}

