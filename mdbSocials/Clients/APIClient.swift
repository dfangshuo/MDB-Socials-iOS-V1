//
//  APIClient.swift
//  FirebaseDemoMaster
//
//  Created by Sahil Lamba on 2/16/18.
//  Copyright © 2018 Vidya Ravikumar. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import SwiftyJSON
import ObjectMapper
import PromiseKit
import Haneke

class APIClient {
 
    /**********************************************************/
    /****************** FETCH POSTS ***************************/
    /**********************************************************/
    
    // no promises
    static func fetchPosts(withBlock: @escaping (Post) -> ()) {
        //TODO: Implement a method to fetch posts with Firebase!
        let ref = Database.database().reference()
        ref.child("Posts").observe(.childAdded, with: { (snapshot) in

            let json = JSON(snapshot.value)
            if var result = json.dictionaryObject {
                result["key"] = snapshot.key
                if let post = Post(JSON: result) {
                    withBlock(post)
                }
            }
        })
    }
    
    static func fetchPost(id: String) -> Promise<Post> {
        return Promise {fulfill, reject in
            let ref = Database.database().reference()
            ref.child("Posts").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                let json = JSON(snapshot.value)
                if var result = json.dictionaryObject {
                    result["id"] = snapshot.key
                    if let post = Post(JSON: result) {
//                        print("I MADE THE POST")
//                        print(post.eventTitle)
                        fulfill(post)
                    }
                }
            })
        }
    }
    
    /**********************************************************/
    /****************** FETCH USER ****************************/
    /**********************************************************/

    
    static func fetchUser(id: String) -> Promise<Users> {
        return Promise {fulfill, reject in
            let ref = Database.database().reference()
            ref.child("Users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                let json = JSON(snapshot.value)
                if var result = json.dictionaryObject {
                    result["id"] = snapshot.key
                    if let user = Users(JSON: result) {
                        fulfill(user)
                    }
                }
            })
        }
    }
    
    /**********************************************************/
    /******************** MAKE POST ***************************/
    /**********************************************************/

    static func createNewPost(postsRef: DatabaseReference,key: String, title: String, postText: String, poster: String,
                              imageUrl: String, posterId: String, num: [String], timePicked: String)
        // ONE: take in a bunch of arguments, key-value pairs of your desired JSON Object
    {
        // TWO: put these key-value pairs in a dictionary which you then...
        let newPost = ["title" : title, "text": postText, "poster": poster, "imageUrl": imageUrl, "posterId": posterId, "num": num, "timePicked": timePicked] as [String : Any]
        //THREE: upload into FB
        let childUpdates = ["/\(key)/": newPost]
        postsRef.updateChildValues(childUpdates)
    }
    
    /**********************************************************/
    /******************** MAKE USER ***************************/
    /**********************************************************/
    
    static func createNewUser(id: String, name: String, username: String, imageURL: String) {
        let usersRef = Database.database().reference().child("Users")
        let newUser = ["name": name, "username": username, "imageURL": imageURL, "id": id]
        let childUpdates = ["/\(id)/": newUser]
        usersRef.updateChildValues(childUpdates)
    }
}



