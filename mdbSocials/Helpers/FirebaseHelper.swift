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
    
//    static func getUserName(id: String, completion: @escaping (String) -> ()) {
//        var username: String!
//        APIClient.fetchUser(id: id).then{ (User) in
//            username =  User.name
//            }.then{
//                completion(username)
//        }
//    }
    
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
    
//    static func makeUserPicOptional(userModel: Users ,email: String, password: String, dictOfInfo: [String:Any], completion: @escaping (String) -> (), withBlock1: @escaping () -> (), withBlock2: @escaping () -> ()) {
//        let name = dictOfInfo["name"] as! String
//        let username = dictOfInfo["username"] as!String
//        var userId: String!
//
//        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
//            if error == nil && user != nil {
//
//                APIClient.createNewUser(id: (user?.uid)!, name: name, username: username, imageURL: "nil")
//                userModel.name = name
//                userId = (user?.uid)!
//                userModel.id = userId
//
//                print("User created!")
//                withBlock1()
//                completion(userId)
//            }
//            else {
//                print("Error Creating User: \(error.debugDescription)")
//                withBlock2()
//            }
//        })
//
//    }
    
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
    
//    static func makeUserPicOptional(userModel: Users ,email: String, password: String, dictOfInfo: [String:Any],img: UIImage?, withBlock1: @escaping () -> (), withBlock2: @escaping () -> ()) {
//        var inURL = "nil"
//
//        let usersRef = Database.database().reference().child("Users")
//        let key = usersRef.childByAutoId().key
//
//        let name = dictOfInfo["name"] as! String
//        let username = dictOfInfo["username"] as!String
//
//        if img == nil {
//            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
//                if error == nil && user != nil {
//
//                    APIClient.createNewUser(id: (user?.uid)!, name: name, username: username, imageURL: inURL)
//                    userModel.name = name
//                    userModel.id = (user?.uid)!
//                    print("User created!")
//                    withBlock1()
//                }
//                else {
//                    print("Error Creating User: \(error.debugDescription)")
//                    withBlock2()
//                }
//            })
//        } else {
//            print("I WENT IN HERE")
//
//            let storageRef = Storage.storage().reference()
//            let data = UIImageJPEGRepresentation(img!, 1.0)
//
//            // Create a reference to the file you want to upload
//            let events = storageRef.child(key)
//            let metadata = StorageMetadata()
//            metadata.contentType = "image/jpeg"
//
//            let uploadTask = events.putData(data!, metadata: nil) { (metadata, error) in
//                guard let metadata = metadata else {
//                    print(error?.localizedDescription)
//                    return
//                }
//
//                print("I WENT IN HERE 2")
//
//                // Metadata contains file metadata such as size, content-type, and download URL.
//                inURL = (metadata.downloadURL()?.absoluteString)!
//                Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
//                    if error == nil && user != nil {
//                        print("I WENT IN HERE 3")
//
//                        print("User created!")
//                        let name = dictOfInfo["name"] as! String
//                        let username = dictOfInfo["username"] as!String
//
//                        APIClient.createNewUser(id: (user?.uid)!, name: name, username: username, imageURL: inURL)
//                        userModel.name = name
//                        userModel.id = (user?.uid)!
//                        withBlock1()
//                    }
//                    else {
//                        print("Error Creating User: \(error.debugDescription)")
//                        withBlock2()
//                    }
//                })
//            }
//        }
//    }
    
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
    
    // v1 with promise kit
    //    static func downloadPic(imageName: String) -> Promise<UIImage> {
    //        return Promise {fulfill, reject in
    //            let storageRef = Storage.storage().reference()
    //            let imageRef = storageRef.child("\(imageName)")
    //            imageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
    //                if let error = error {
    //                    print("ERROR: \(error.localizedDescription)")
    //                } else {
    //                    let toDisplay = UIImage(data: data!)
    //                    fulfill(toDisplay!)
    //                }
    //            }
    //        }
    //    }
    
//    static func makePostNoPic(postsRef: DatabaseReference,key: String, title: String, postText: String, poster: String, posterId: String, num: Int, timePicked: String){
//        APIClient.createNewPost(postsRef: postsRef, key: key, title: title, postText: postText, poster: poster, imageUrl: "nil", posterId: posterId, num: num, timePicked: timePicked)
//    }
//
//    static func uploadPicMakePost(postsRef: DatabaseReference,key: String, title: String, postText: String, poster: String, posterId: String, num: Int, timePicked: String, imgView: UIImageView) {
//        let storageRef = Storage.storage().reference()
//        let data = UIImageJPEGRepresentation(imgView.image!, 1.0)
//
//        // Create a reference to the file you want to upload
//        let events = storageRef.child(key)
//        let metadata = StorageMetadata()
//        metadata.contentType = "image/jpeg"
//
//        let uploadTask = events.putData(data!, metadata: nil) { (metadata, error) in
//            guard let metadata = metadata else {
//                return
//            }
//            // Metadata contains file metadata such as size, content-type, and download URL.
//            let downloadURL = metadata.downloadURL()?.absoluteString
//            APIClient.createNewPost(postsRef: postsRef, key: key, title: title, postText: postText, poster: poster, imageUrl: downloadURL!, posterId: posterId, num: num, timePicked: timePicked)
//        }
//    }
    
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
            
//            let storageRef = Storage.storage().reference()
//            let imageRef = storageRef.child("\(imageName)")
//            imageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
//                if let error = error {
//                    print("ERROR: \(error.localizedDescription)")
//                } else {
//                    let toDisplay = UIImage(data: data!)
//                    fulfill(toDisplay!)
//                }
//            }
//        }
//    }
    
    // v1 with promise kit
//    static func downloadPic(imageName: String) -> Promise<UIImage> {
//        return Promise {fulfill, reject in
//            let storageRef = Storage.storage().reference()
//            let imageRef = storageRef.child("\(imageName)")
//            imageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
//                if let error = error {
//                    print("ERROR: \(error.localizedDescription)")
//                } else {
//                    let toDisplay = UIImage(data: data!)
//                    fulfill(toDisplay!)
//                }
//            }
//        }
//    }
    
    // v0 original
//    static func downloadPic(imageName: String, withBlock: @escaping (UIImage) -> ()) {
//        // create a storage ref and...
//        let storageRef = Storage.storage().reference()
//        // from that storage ref, create an imageRef to THAT IMAGE YOU WANT
//        let imageRef = storageRef.child("\(imageName)")
//        print(imageRef)
//
//        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
//        imageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
//        if let error = error {
//            print("ERROR: \(error.localizedDescription)")
//        } else {
//            let toDisplay = UIImage(data: data!)
//            withBlock(toDisplay!)
//            }
//        }
//    }
    
    static func currUser() -> User? {
        return Auth.auth().currentUser
    }
    
    static func currUserID() -> String {
        return currUser()!.uid
    }
}



