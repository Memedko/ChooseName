//
//  UIView+Ext.swift
//  ChooseName
//
//  Created by Inna Levandovskaya on 01.02.2021.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField

extension UIView {
    
    func textFieldCreate(_ delegate: UITextFieldDelegate, _ title:String = "", _ placeholder:String = "", _ keyboardType:UIReturnKeyType = .default, _ tag:Int = 0) {
        let textField = SkyFloatingLabelTextField(frame: CGRect(x: 0, y: 10, width: self.frame.size.width, height: 50))
        textField.placeholder = placeholder
        textField.title = title
        textField.tintColor = .white
        textField.textColor = UIColor.init(named: "MainTextColor") ?? UIColor.white.withAlphaComponent(0.7)
        textField.lineColor = UIColor.init(named: "SecondaryTextColor") ?? UIColor.white.withAlphaComponent(0.7)
        textField.selectedTitleColor = UIColor.init(named: "NoteTextColor") ?? UIColor.white.withAlphaComponent(0.5)
        textField.selectedLineColor = UIColor.init(named: "SecondaryTextColor") ?? UIColor.white.withAlphaComponent(0.7)
        textField.titleColor = UIColor.init(named: "NoteTextColor") ?? UIColor.white.withAlphaComponent(0.5)
        textField.textColor = UIColor.init(named: "SecondaryTextColor") ?? UIColor.white.withAlphaComponent(0.7)
        textField.font = UIFont.init(name: "MontserratAlternates-Medium", size: 17)
        textField.placeholderColor = UIColor.init(named: "NoteTextColor") ?? UIColor.white.withAlphaComponent(0.5)
        textField.titleFont = UIFont.init(name: "MontserratAlternates-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14)
        textField.titleFormatter = { $0 }
        textField.returnKeyType = keyboardType
        textField.delegate = delegate
        textField.tag = tag
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textField)
        let constraints = [
            textField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            textField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}
