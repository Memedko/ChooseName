//
//  CNCardChildTableViewCell.swift
//  ChooseName
//
//  Created by Inna Levandovskaya on 23.07.2023.
//

import UIKit

class CNCardChildTableViewCell: UITableViewCell {
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var labelAge: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    var child:Child? {
        didSet {
            labelName.text = child?.name ?? ""
            labelDescription.text = child?.parents ?? ""
            var age = 0
            if let birthYear = child?.birthday, birthYear != 0 {
                if let deathYear = child?.yearOfDeath, deathYear != 0 {
                    age = deathYear - birthYear
                } else {
                    let currentYear = Calendar.current.component(.year, from: Date())
                    age = currentYear - birthYear
                }
            }
            if age < 3 {
                imgIcon.image = UIImage.init(named: "icon_child_0-2")
            } else if age > 2 && age < 7 {
                imgIcon.image = UIImage.init(named: "icon_child_3-6")
            } else if age > 6 && age < 13 {
                imgIcon.image = UIImage.init(named: "icon_child_7-12")
            } else if age > 12 && age < 18 {
                imgIcon.image = UIImage.init(named: "icon_child_13-17")
            } else if age > 17 && age < 23 {
                imgIcon.image = UIImage.init(named: "icon_child_18-22")
            } else {
                imgIcon.image = UIImage.init(named: "icon_child_23")
            }
            labelAge.text = ageLabel(age)
        }
    }
    
    func ageLabel(_ age:Int) -> String {
        var label = "(\(age) "
        let yearType1 = [1, 21, 31, 41, 51, 61, 71, 81, 91, 101] // рік
        let yearType2 = [2, 3, 4, 22, 23, 24, 32, 33, 34, 42, 43, 44, 52, 53, 54, 62, 63, 64, 72, 73, 74, 82, 83, 84, 92, 93, 94, 102, 103, 104] // роки
        if yearType1.contains(age) {
            label += "рік"
        } else if yearType2.contains(age) {
            label += "роки"
        } else {
            label += "років"
        }
        return label + ")"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
