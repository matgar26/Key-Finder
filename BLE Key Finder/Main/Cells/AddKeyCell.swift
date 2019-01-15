//
//  AddKeyCell.swift
//  BLE Key Finder
//
//  Created by Matt Gardner on 12/17/18.
//  Copyright © 2018 Matt Gardner. All rights reserved.
//

import UIKit

class AddKeyCell: UITableViewCell {
    
    static var cellHeight: CGFloat = 75

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var ringImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ringImageView.tintColor = Color.secondary
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
