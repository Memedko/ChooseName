//
//  CNCardLangsTableViewCell.swift
//  ChooseName
//
//  Created by Inna Levandovskaya on 12.06.2023.
//

import UIKit

class CNCardLangsTableViewCell: UITableViewCell {
    @IBOutlet weak var labelValue: UILabel!
    var content:String? {
        didSet {
            let langs = content?.components(separatedBy: ";") ?? []
            var text = ""
            var myMutableString = NSMutableAttributedString()
            let attrsLang = [NSAttributedString.Key.font : UIFont.init(name: "MontserratAlternates", size: 15) ?? UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : (UIColor.init(named: "NoteTextColor") ?? .white)]
            let attrsName = [NSAttributedString.Key.font : UIFont.init(name: "MontserratAlternates-Medium", size: 17) ?? UIFont.boldSystemFont(ofSize: 19), NSAttributedString.Key.foregroundColor : (UIColor.init(named: "SecondaryTextColor") ?? .white)]
            for (index, lang) in langs.enumerated() {
                let line = lang.components(separatedBy: ":")
                if line.count > 1 {
                    let lang = line[0].trimmingCharacters(in: .whitespaces) + " "
                    let name = line[1].trimmingCharacters(in: .whitespaces) + (index == (langs.count - 1) ? "" : "\n")
                    text += lang + name
                    let attributedLang = NSMutableAttributedString(string: lang, attributes:attrsLang)
                    myMutableString.append(attributedLang)
                    let attributedName = NSMutableAttributedString(string: name, attributes:attrsName)
                    myMutableString.append(attributedName)
                } else {
                    text += lang.trimmingCharacters(in: .whitespaces) + "\n"
                }
            }
            labelValue.text = text
            labelValue.attributedText = myMutableString
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }


}
