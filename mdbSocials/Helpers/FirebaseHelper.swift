//
//  imageHelper.swift
//  mdbSocials
//
//  Created by Fang on 2/22/18.
//  Copyright © 2018 fang. All rights reserved.
//

import Foundation
import Firebase
import PromiseKit
import Haneke

class FirebaseHelper {
    
    static func getUserName(id: String) -> Promise<String> {
        return Promise { fulfill, reject in
            var username: String!
            APIClient.fetchUser(id: id).then{ (User) in
                username =  User.name
                }.then{
                    fulfill(username)
            }
        }
    }
    
    static func makeUserPicOptional(userModel: Users ,email: String, password: String, dictOfInfo: [String:Any], successAction: @escaping () -> (), failureAction: @escaping () -> ()) -> Promise<String> {
        return Promise {fulfill, reject in
            let name = dictOfInfo["name"] as! String
            let username = dictOfInfo["username"] as!String
            var userId: String!
            
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if error == nil && user != nil {
                    
                    APIClient.createNewUser(id: (user?.uid)!, name: name, username: username, imageURL: "nil")
                    userModel.name = name
                    userId = (user?.uid)!
                    userModel.id = userId
                    
                    print("User created!")
                    successAction()
                    fulfill(userId)
                }
                else {
                    print("Error Creating User: \(error.debugDescription)")
                    failureAction()
                }
            })
        }
    }
    
    static func putImageInStorage(img: UIImage?, userId: String) {
        if img != nil {
        
            let usersRef = Database.database().reference().child("Users")
            let key = usersRef.childByAutoId().key
            
            let storageRef = Storage.storage().reference()
            let data = UIImageJPEGRepresentation(img!, 1.0)
            
            let events = storageRef.child(key)
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let uploadTask = events.putData(data!, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    print("THIS IS THE ERROR")
                    print(error?.localizedDescription)
                    return
                }
                let inURL = (metadata.downloadURL()?.absoluteString)!
                let newURL = ["\(userId)/imageURL": inURL]
                usersRef.updateChildValues(newURL)
            }
    }
    }
    
    static func makePostPicOptional(title: String, postText: String, poster: String, posterId: String, num: [String], timePicked: String, img: UIImage?) {
        let postsRef = Database.database().reference().child("Posts")
        let key = postsRef.childByAutoId().key
        var inURL = "nil"
        
        if img == nil {
            APIClient.createNewPost(postsRef: postsRef, key: key, title: title, postText: postText, poster: poster, imageUrl: inURL, posterId: posterId, num: num, timePicked: timePicked)
        } else {
            let storageRef = Storage.storage().reference()
            let data = UIImageJPEGRepresentation(img!, 1.0)

            // Create a reference to the file you want to upload
            let events = storageRef.child(key)
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"

            let uploadTask = events.putData(data!, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    return
                }
                // Metadata contains file metadata such as size, content-type, and download URL.
                inURL = (metadata.downloadURL()?.absoluteString)!
                APIClient.createNewPost(postsRef: postsRef, key: key, title: title, postText: postText, poster: poster, imageUrl: inURL, posterId: posterId, num: num, timePicked: timePicked)
            }
        }
    }
    
    static func downloadPic(withURL: String) -> Promise<UIImage> {
        return Promise {fulfill, reject in
            let cache = Shared.imageCache
            if let imageURL = URL(string: withURL) {
                cache.fetch(URL: imageURL as URL).onSuccess({img in
                    fulfill(img)
                })
            }
        }
    }
    
    static func uploadImg(key: String, imgView: UIImageView) {
        let storageRef = Storage.storage().reference()
        let data = UIImageJPEGRepresentation(imgView.image!, 1.0)
        
        // Create a reference to the file you want to upload
        let events = storageRef.child(key)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
    
        let uploadTask = events.putData(data!, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                return
            }
        }
    }
           
    static func currUser() -> User? {
        return Auth.auth().currentUser
    }
    
    static func currUserID() -> String {
        return currUser()!.uid
    }
}



