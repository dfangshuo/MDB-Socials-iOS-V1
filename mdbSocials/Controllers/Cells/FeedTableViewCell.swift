//
//  FeedTableViewCell.swift
//  mdbSocials
//
//  Created by Fang on 2/21/18.
//  Copyright © 2018 fang. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    var img: UIImageView!
    var name: UILabel!
    var num: UILabel!
    var poster: UILabel!
    
    override func awakeFromNib() {
        img = UIImageView(frame: CGRect(x:20, y:15, width: 120, height:120))
        img.image = #imageLiteral(resourceName: "MDB Cover")
        img.layer.cornerRadius = 10
        img.clipsToBounds = true
        img.layer.borderColor = UIColor.black.cgColor
        contentView.addSubview(img) //remember to add UI elements to the contentView not the cell itself
        
        name = UILabel(frame: CGRect(x:167, y:18, width: 240, height:30))
        name.textColor = UIColor.black
//        name.text = "My title goes here"
        name.font = UIFont.boldSystemFont(ofSize: 25)
        contentView.addSubview(name)
        
        num = UILabel(frame: CGRect(x:167, y:84, width: 300, height:30))
        num.textColor = UIColor.darkGray
        contentView.addSubview(num)
        
        poster = UILabel(frame: CGRect(x:167, y:51, width: 240, height:30))
        poster.textColor = UIColor.darkGray
        poster.font = UIFont.boldSystemFont(ofSize: 20)
        contentView.addSubview(poster)
    }
}
