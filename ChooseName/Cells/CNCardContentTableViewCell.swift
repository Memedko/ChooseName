//
//  CNCardContentTableViewCell.swift
//  ChooseName
//
//  Created by Inna Levandovskaya on 02.02.2021.
//

import UIKit

class CNCardContentTableViewCell: UITableViewCell {
    @IBOutlet weak var labelContent: UILabel!
    var content:String? {
        didSet {
            labelContent.text = content
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
