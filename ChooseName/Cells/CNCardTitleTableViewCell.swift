//
//  CNCardTitleTableViewCell.swift
//  ChooseName
//
//  Created by Inna Levandovskaya on 02.02.2021.
//

import UIKit

class CNCardTitleTableViewCell: UITableViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet var constraintTitleLeft: NSLayoutConstraint?
    var icon:UIImage?
    var title:String? {
        didSet {
            labelTitle.text = title
            if icon != nil {
                imgIcon.image = icon
                imgIcon.isHidden = false
                constraintTitleLeft?.priority = UILayoutPriority(rawValue: 900)
            } else {
                imgIcon.isHidden = true
                constraintTitleLeft?.priority = UILayoutPriority(rawValue: 700)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
