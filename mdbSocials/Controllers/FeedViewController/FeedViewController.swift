//
//  FeedViewController.swift
//  mdbSocials
//
//  Created by Fang on 2/20/18.
//  Copyright © 2018 fang. All rights reserved.
//

import UIKit
import ChameleonFramework

class FeedViewController: UIViewController {
    
    var tableView: UITableView!
    var indexSelected: Int!
    
    var postDir: [Post] = []
    var nameArray: [String] = []
    // user model
    var currUser: Users!
    let AuthUser = FirebaseHelper.currUser()
    
//    var userInterestedEvents: [String] = []
    
    override func viewWillAppear(_ animated: Bool) {
        
        APIClient.fetchPosts(withBlock: {(posts) in
            self.tableView.reloadData()
        })

//        APIClient.fetchPosts().then{(posts) in
//            self.tableView.reloadData()
//        }
        
        // fetch user
        APIClient.fetchUser(id: (AuthUser?.uid)!).then{ x -> Void in
            print("X is ")
            print(x)
            print(x.name)
            print(x.id)
            print(x.interestedEvents)
            self.currUser = x
            print(self.currUser)
            
            }.then{ _ -> Void in
                self.idToName(id: self.currUser.interestedEvents)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // fetch user
//        APIClient.fetchUser(id: (AuthUser?.uid)!).then{ x -> Void in
//            print("X is ")
//            print(x)
//            print(x.name)
//            print(x.id)
//            print(x.interestedEvents)
//            self.currUser = x
//            print(self.currUser)
//
//            }.then{ _ -> Void in
////                        print("CURR USER ")
////                        print(self.currUser)
////                        print(self.currUser.name)
////                        print(self.currUser.id)
////                        print(self.currUser.interestedEvents)
//
////                DispatchQueue.main.async {
//                    self.idToName(id: self.currUser.interestedEvents)
////                }
////                print("printing name array")
////                print(self.nameArray)
//
//            }
////            .then{_ -> Void in
////                let secondTab = self.tabBarController?.viewControllers![1] as! EventsViewController
////                secondTab.interestedEventz = self.nameArray
//                let secondTab = self.tabBarController?.viewControllers![1] as! EventsViewController
//                print("ID TO NAME DONE")
//                print(self.nameArray)
//                secondTab.interestedEventz = self.nameArray
////                secondTab.interestedEventz = self.currUser.interestedEvents
//        }
//        var secondTab = self.tabBarController?.viewControllers![1] as! EventsViewController
//        print("CURR USER ")
//        print(currUser)
//        print(currUser.name)
//        print("CURR USER INTERESTED")
//        print(currUser.interestedEvents)
//        secondTab.interestedEventz = currUser.interestedEvents
        
        
        self.tabBarItem.title = "Feed"
        makeNavBar()
        makeTable()
        
        // fetch posts
//        APIClient.fetchPosts().then{(posts) in
//            self.postDir.insert(posts, at: 0)
//            }.then {_ in
//                DispatchQueue.main.async {
//                     self.tableView.reloadData()
//                }
//
//        }
        
        APIClient.fetchPosts(withBlock: {(posts) in
            self.postDir.insert(posts, at: 0)
            self.tableView.reloadData()
        })
    }
    
    func idToName(id: [String]) {
//        var names: [String] = []
//        DispatchQueue.main.async {
        let group = DispatchGroup()
            nameArray = []
            for i in id {
                print("IM RUNNING")
                group.enter()
                APIClient.fetchPost(id: i).then{ post -> Void in
                    print("I APPENDED")
//                    print(post.eventTitle)
//                    names += [post.eventTitle!]
                    self.nameArray.append(post.eventTitle!)
                    print("middle of func")
                    print(self.nameArray)
                    group.leave()
//                    print(names)
                    }
//                print(names)
            }
        group.notify(queue: .main) {
            let secondTab = self.tabBarController?.viewControllers![1] as! EventsViewController
            secondTab.interestedEventz = self.nameArray
        }
//            self.nameArray = names
//            self.nameArray = names.map { $0 }
            print("end of func")
            print(self.nameArray)
//        }
    }
    
    /*************************************************************************************************/
    /************************************ BUTTON FNS *************************************************/
    /*************************************************************************************************/
    
    @objc func logOut() {
        UserAuthHelper.logOut().then{(true) in self.performSegue(withIdentifier: "logOut", sender: self)}
    }
    
    @objc func toNewPost() {
        self.performSegue(withIdentifier: "newPost", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "newPost" {
            let VC = segue.destination as! NewSocialViewController
            VC.postingUser = currUser
        } else if segue.identifier == "moreDetails" {
            let VC = segue.destination as! DetailViewController
//            VC.info = postDir[indexSelected]
            VC.postObjs = postDir
            VC.indice = indexSelected
            VC.userRN = currUser
        }
    }
}
