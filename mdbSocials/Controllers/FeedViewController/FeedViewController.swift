//
//  FeedViewController.swift
//  mdbSocials
//
//  Created by Fang on 2/20/18.
//  Copyright © 2018 fang. All rights reserved.
//

import UIKit
import ChameleonFramework

enum NSComparisonResult : Int {
    case OrderedAscending
    case OrderedSame
    case OrderedDescending
}

class FeedViewController: UIViewController {
    
    var tableView: UITableView!
    var indexSelected: Int!
    
    var postDir: [Post] = []
    var unfilteredPostDir: [Post] = []
    var nameArray: [String] = []
    
    // user model
    var currUser: Users!
    let AuthUser = FirebaseHelper.currUser()
    
    override func viewWillAppear(_ animated: Bool) {
        
        // fetch user
        APIClient.fetchUser(id: (AuthUser?.uid)!).then{x in
            self.currUser = x
            }.then{ _ -> Void in
                self.idToName(id: self.currUser.interestedEvents)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarItem.title = "Feed"

        makeNavBar()
        makeTable()
        
        APIClient.fetchPosts(withBlock: {(posts) in
            self.unfilteredPostDir.insert(posts, at: 0)
            self.postDir = []
            for post in self.unfilteredPostDir {
                let dateFormatter: DateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
                let tempDate = dateFormatter.date(from: post.dateSelected!)
                let eventDate: NSDate = tempDate! as NSDate
                let compareResult: ComparisonResult = Date().compare(eventDate as Date)
                if compareResult != ComparisonResult.orderedDescending {
                    self.postDir.insert(post, at:0)
                }
            }
            self.tableView.reloadData()
        })
}
    
    func idToName(id: [String]) {
        let group = DispatchGroup()
            nameArray = []
            for i in id {
                group.enter()
                APIClient.fetchPost(id: i).then{ post -> Void in
                    self.nameArray.append(post.eventTitle!)
                    group.leave()
                    }
            }
        group.notify(queue: .main) {
            let secondTab = self.tabBarController?.viewControllers![1] as! EventsViewController
            secondTab.interestedEventz = self.nameArray
        }
            print("end of func")
            print(self.nameArray)
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
            VC.postObjs = postDir
            VC.indice = indexSelected
            VC.userRN = currUser
        }
    }
}
