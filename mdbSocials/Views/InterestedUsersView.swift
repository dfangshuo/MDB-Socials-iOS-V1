//
//  InterestedUsersView.swift
//  mdbSocials
//
//  Created by Fang on 3/1/18.
//  Copyright © 2018 fang. All rights reserved.
//

import UIKit

class InterestedUsersView: UIView {
    var titleLabel: UILabel!
    var names: UILabel!
    var listOfNames: [String] = []
    var tableView: UITableView!
//    String!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 3
        clipsToBounds = true
        backgroundColor = .white
        
//        listOfNames = "A label\nwith\nmultiline text."
//        print(listOfNames)
//        titleLabel = UILabel(frame:CGRect(x: 10, y: 100, width: frame.width, height: 50))
//        titleLabel.text =  "HERE'S WHO'S GOING"
//        addSubview(titleLabel)
//        
//        names = UILabel(frame:CGRect(x: 20, y: 20, width: frame.width, height: frame.height))
//        names.text = ""
//        names.numberOfLines = 0
//        names.lineBreakMode = .byTruncatingTail
//        names.minimumScaleFactor = 0.8
//        addSubview(names)
        makeTable()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeTable() {
        tableView = UITableView(frame: frame,
                                style: UITableViewStyle.plain)
        tableView.register(InterestedUsersTableViewCell.self, forCellReuseIdentifier: "interested")
        tableView.clipsToBounds = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        addSubview(tableView)
    }
    
}

extension InterestedUsersView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "interested", for: indexPath)
            as! InterestedUsersTableViewCell
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        cell.awakeFromNib()
        
        cell.name.text = listOfNames[indexPath.row]
        print("getting in here")
        print(listOfNames[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
}
