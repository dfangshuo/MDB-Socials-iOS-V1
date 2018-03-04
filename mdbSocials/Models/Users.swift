//
//  User.swift
//  FirebaseDemoMaster
//
//  Created by Vidya Ravikumar on 9/22/17.
//  Copyright © 2017 Vidya Ravikumar. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import Firebase

class Users: Mappable {
    
    var name: String?
    var email: String?
    var id: String?
    var interestedEvents: [String] = []
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name        <- map["name"]
        email       <- map["email"]
        id          <- map["id"]
        interestedEvents   <- map["interestedEvents"]
    }
    
//    init(id: String, userDict: [String:Any]?) {
//        self.id = id
//        if userDict != nil {
//            if let name = userDict!["name"] as? String {
//                self.name = name
//            }
//            if let email = userDict!["email"] as? String {
//                self.email = email
//            }
//
//        }
//    }
    
    static func getCurrentUser(withId: String, block: @escaping (Users) -> ()) {
        APIClient.fetchUser(id: withId).then{(users) in
            block(users)
        }
        
//        APIClient.fetchUser(id: withId, withBlock: {(users) in
//            block(users)
//        })
    }
    
    func addInterestedEvent(id: String) {
        //update local array
        interestedEvents.append(id)
        
        // update database
        let ref = Database.database().reference().child("Users")
        let childUpdates = ["\(self.id!)/interestedEvents": interestedEvents]
        ref.updateChildValues(childUpdates)
    }
    
    func rmInterestedEvent(id: String) {
        interestedEvents.popLast()
        let ref = Database.database().reference().child("Users")
        let childUpdates = ["\(self.id!)/interestedEvents": interestedEvents]
        ref.updateChildValues(childUpdates)
    }
    
    
}

