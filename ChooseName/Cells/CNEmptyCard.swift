//
//  CNEmptyCard.swift
//  ChooseName
//
//  Created by Inna Levandovskaya on 02.02.2021.
//

import UIKit

class CNEmptyCard: UIView {
    @IBOutlet weak var labelEmpty: UILabel!

    override func draw(_ rect: CGRect) {
        labelEmpty.text = "Card.Empty".localized()
    }
    
}
