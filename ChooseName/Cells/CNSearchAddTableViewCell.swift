//
//  CNSearchAddTableViewCell.swift
//  ChooseName
//
//  Created by Inna Levandovskaya on 07.03.2021.
//

import UIKit

class CNSearchAddTableViewCell: UITableViewCell {
    @IBOutlet weak var viewDivider: UIView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    var isLast:Bool = false {
        didSet {
            viewDivider.isHidden = !isLast
        }
    }
    var name:Name? {
        didSet {
            labelName.text = name?.name
            if name?.select == 1 {
                labelName.alpha = 0.4
                imgIcon.image = UIImage.init(named: "icon_yes_middle")
            } else if name?.select == -1 {
                labelName.alpha = 0.4
                imgIcon.image = UIImage.init(named: "icon_no_middle")
            } else {
                labelName.alpha = 1
                imgIcon.image = nil
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
