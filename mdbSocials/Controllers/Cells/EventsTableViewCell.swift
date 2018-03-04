//
//  EventsViewControllerTableViewCell.swift
//  mdbSocials
//
//  Created by Fang on 3/2/18.
//  Copyright © 2018 fang. All rights reserved.
//

import UIKit

class EventsTableViewCell: UITableViewCell {
    var events: UILabel!
    
    override func awakeFromNib() {
//        events = UILabel(frame: CGRect(x:10, y:30, width: 330, height:30))
//        events.textColor = UIColor.black
//        events.text = "THIS IS MY TEXT"
//        //        events = "My title goes here"
//        events.font = UIFont.boldSystemFont(ofSize: 25)
//        contentView.addSubview(events)
        
        events = UILabel(frame: CGRect(x:40, y:18, width: 240, height:30))
        events.textColor = UIColor.black
        //        name.text = "My title goes here"
        events.font = UIFont.boldSystemFont(ofSize: 25)
        contentView.addSubview(events)
    }
    
}
