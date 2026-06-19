//
//  CNCardSongTableViewCell.swift
//  ChooseName
//
//  Created by Inna Levandovskaya on 02.02.2021.
//

import UIKit

class CNCardSongTableViewCell: UITableViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSinger: UILabel!
    var song:Song? {
        didSet {
            labelTitle.text = song?.title
            labelSinger.text = song?.singer
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func onLink(_ sender: Any?) {
        if let url = URL(string: song?.url ?? "") {
            UIApplication.shared.open(url)
        }
    }

}
