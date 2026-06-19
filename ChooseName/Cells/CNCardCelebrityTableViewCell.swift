//
//  CNcellCelebrityTableViewCell.swift
//  ChooseName
//
//  Created by Inna Levandovskaya on 02.02.2021.
//

import UIKit
import SDWebImage

class CNCardCelebrityTableViewCell: UITableViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var viewImg: UIView!
    @IBOutlet weak var labelDescription: UILabel!
    var wikiUrl:String?
    var celebrity:Celebrity? {
        didSet {
            if let photoUrl = celebrity?.photo {
                img.sd_setImage(with: URL(string: photoUrl), placeholderImage: UIImage.init(named: "photo_defaulte"))
                viewImg.isHidden = false
            } else {
                viewImg.isHidden = true
            }
            labelName.text = celebrity?.name
            labelDescription.text = celebrity?.description
            wikiUrl = celebrity?.url
        }
    }
    
    var character:Сharacter? {
        didSet {
            if let photoUrl = character?.photo {
                img.sd_setImage(with: URL(string: photoUrl), placeholderImage: UIImage.init(named: "photo_defaulte"))
                viewImg.isHidden = false
            } else {
                viewImg.isHidden = true
            }
            labelName.text = character?.name
            labelDescription.text = character?.description
            wikiUrl = character?.url
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        img.layer.cornerRadius = 5
        img.layer.borderWidth = 2
        img.layer.borderColor = UIColor.init(white: 1, alpha: 0.5).cgColor
    }
    
    @IBAction func onLink(_ sender: Any?) {
        if let url = URL(string: wikiUrl ?? "") {
            UIApplication.shared.open(url)
        }
    }

}
