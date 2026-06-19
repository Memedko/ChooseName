//
//  CNCardSameNameTableViewCell.swift
//  ChooseName
//
//  Created by Inna Levandovskaya on 11.04.2021.
//

import UIKit

class CNCardSameNameTableViewCell: UITableViewCell {
    @IBOutlet weak var viewDivider: UIView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var imgLiked: UIImageView!
    @IBOutlet weak var imgDisliked: UIImageView!
    var isLast:Bool = false {
        didSet {
            viewDivider.isHidden = !isLast
        }
    }
    var name:String? {
        didSet {
            labelName.text = name
            imgIcon.isHidden = true
            imgLiked.isHidden = true
        }
    }
    
    var nameRecord:Name? {
        didSet {
            labelName.text = nameRecord?.name ?? ""
            imgIcon.isHidden = false
            if nameRecord?.select == 1 {
                imgLiked.isHidden = false
                imgDisliked.isHidden = true
            } else if nameRecord?.select == -1 {
                imgLiked.isHidden = true
                imgDisliked.isHidden = false
            } else {
                imgLiked.isHidden = true
                imgDisliked.isHidden = true
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
