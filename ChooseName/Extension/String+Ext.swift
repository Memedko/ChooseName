//
//  String+Ext.swift
//  ChooseName
//
//  Created by Inna Levandovskaya on 13.12.2020.
//

import Foundation

extension String {
    
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "\(self)", comment: "")
    }
    
}
