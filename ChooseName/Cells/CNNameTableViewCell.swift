//
//  NameTableViewCell.swift
//  ChooseName
//
//  Created by Inna Levandovskaya on 20.12.2020.
//

import UIKit

class CNNameTableViewCell: UITableViewCell {
    @IBOutlet weak var labelName: UILabel!
    
    public var name: String? {
        didSet {
            labelName.text = name
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
