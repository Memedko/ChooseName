//
//  CNCardLastNameTableViewCell.swift
//  ChooseName
//
//  Created by Inna Levandovskaya on 02.02.2021.
//

import UIKit

class CNCardLastNameTableViewCell: UITableViewCell {
    @IBOutlet weak var labelName: UILabel!
    var fullName:String? {
        didSet {
            labelName.text = fullName
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }}
