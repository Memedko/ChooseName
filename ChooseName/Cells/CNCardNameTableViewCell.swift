//
//  CNCardNameTableViewCell.swift
//  ChooseName
//
//  Created by Inna Levandovskaya on 02.02.2021.
//

import UIKit

protocol CNCardNameTableViewCellDelegate {
    func onCopyNameID(_ nameID:String)
}

class CNCardNameTableViewCell: UITableViewCell {
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelID: UILabel!
    @IBOutlet weak var btnCopy: UIButton!
    @IBOutlet weak var viewCopy: UIView!
    var name:String? {
        didSet {
            labelName.text = name
            viewCopy.isHidden = Constants.isProd
        }
    }
    var nameID:String? {
        didSet {
            labelID.text = nameID
        }
    }
    var delegate: CNCardNameTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        btnCopy.layer.borderWidth = 1
        btnCopy.layer.borderColor = (UIColor.init(named: "SecondaryTextColor") ?? UIColor.white).cgColor
        btnCopy.layer.cornerRadius = 10
    }
    
    @IBAction func onCopy(_ sender: Any) {
        delegate?.onCopyNameID(labelID.text ?? "")
    }

}
