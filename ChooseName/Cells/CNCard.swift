//
//  CNCard.swift
//  ChooseName
//
//  Created by Inna Levandovskaya on 22.12.2020.
//

import UIKit

protocol CNCardDelegate {
    func onDetails()
}

class CNCard: UIView {
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelLastName: UILabel!
    @IBOutlet weak var btnDetails: UIButton!
    @IBOutlet weak var imgNameStatus: UIImageView!
    @IBOutlet weak var labelNameStatus: UILabel!
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var constraintArrowHeight: NSLayoutConstraint!
    var isMale:Bool = true
    var delegate: CNCardDelegate?
    
    var name:Name? {
        didSet {
            labelName.text = name?.name
            let lastName = isMale ? (UserDefaults.standard.string(forKey: Constants.savedMaleLastName) ?? "") : (UserDefaults.standard.string(forKey: Constants.savedFemaleLastName) ?? "")
            let fatherName = isMale ? (UserDefaults.standard.string(forKey: Constants.savedMaleFatherName) ?? "") : (UserDefaults.standard.string(forKey: Constants.savedFemaleFatherName) ?? "")
            if lastName.count > 0 || fatherName.count > 0 {
                let fullName = (name?.name ?? "") + " " + fatherName + ((lastName.count > 0) ? " " : "") + lastName
                labelLastName.text = fullName
                labelLastName.isHidden = false
            } else {
                labelLastName.isHidden = true
            }
            if name?.select == 1 {
                imgNameStatus.image = UIImage(named: "icon_yes_big")
                imgNameStatus.isHidden = false
                labelNameStatus.text = "Card.YouLikedThisName".localized()
                labelNameStatus.isHidden = false
            } else if name?.select == -1 {
                imgNameStatus.image = UIImage(named: "icon_no_big")
                imgNameStatus.isHidden = false
                labelNameStatus.text = "Card.YouDislikedThisName".localized()
                labelNameStatus.isHidden = false
            } else {
                imgNameStatus.isHidden = true
                labelNameStatus.isHidden = true
            }
            btnDetails.isHidden = name?.value == nil
            imgArrow.isHidden = name?.value == nil
        }
    }

    override func draw(_ rect: CGRect) {
        setupUI()
    }
    
    func setupUI() {
        btnDetails.setTitle("Card.Details".localized(), for: .normal)
        btnDetails.layer.borderWidth = 1
        btnDetails.layer.borderColor = (UIColor.init(named: "SecondaryTextColor") ?? UIColor.white).cgColor
        btnDetails.layer.cornerRadius = 10
    }

    @IBAction func onDetails(_ sender: Any) {
        delegate?.onDetails()
    }
    
}
