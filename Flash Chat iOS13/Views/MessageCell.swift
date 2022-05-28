//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by Sabah Naveed on 11/21/21.
//  Copyright © 2021 Angela Yu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var leftImageView: UIImageView!
    
    //NIB/XIB --> NeXT Interface Builder, type of file
    override func awakeFromNib() { //prepares a receiver for the object created from the nib file
        super.awakeFromNib()
        
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 5 //adapts corner radius to height of text
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
