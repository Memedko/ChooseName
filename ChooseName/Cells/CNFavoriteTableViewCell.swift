//
//  CNFavoriteTableViewCell.swift
//  ChooseName
//
//  Created by Inna Levandovskaya on 23.02.2021.
//

import UIKit

protocol CCNFavoriteTableViewCellDelegate {
    func onLike(_ cell:UITableViewCell)
    func onUnlike(_ cell:UITableViewCell)
}

class CNFavoriteTableViewCell: UITableViewCell {
    @IBOutlet weak var viewDivider: UIView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var btnLike: UIButton!
    
    var delegate: CCNFavoriteTableViewCellDelegate?
    var isLast:Bool = false {
        didSet {
            viewDivider.isHidden = !isLast
        }
    }
    var name:Name? {
        didSet {
            labelName.text = name?.name
            if name?.isLiked ?? false {
                btnLike.setImage(UIImage.init(named: "icon_like_on"), for: .normal)
            } else {
                btnLike.setImage(UIImage.init(named: "icon_like_off"), for: .normal)
            }
            imgArrow.isHidden = name?.nameID == nil || name?.nameID == "" || name?.value == nil
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func onLike(_ sender: Any) {
        if name?.isLiked ?? false {
            btnLike.setImage(UIImage.init(named: "icon_like_off"), for: .normal)
            delegate?.onUnlike(self)
            name?.isLiked = false
        } else {
            btnLike.setImage(UIImage.init(named: "icon_like_on"), for: .normal)
            delegate?.onLike(self)
            name?.isLiked = true
        }
    }

}
