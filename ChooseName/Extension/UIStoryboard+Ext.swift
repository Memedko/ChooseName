//
//  UIStoryboard+Ext.swift
//  ChooseName
//
//  Created by Inna Levandovskaya on 13.12.2020.
//

import Foundation

import UIKit

enum StoryBoardName: String {
    case main = "Main"
}

enum ControllerName: String {
    case introStart = "CNIntroViewController1"
    case main = "CNMainViewController"
    case card = "CNCardViewController"
    case initialForm = "CNInitialViewController"
    case menu = "CNMenuViewController"
    case settings = "CNSettingsViewController"
    case favorites = "CNFavoritesViewController"
    case pipMale = "CNPipMaleViewController"
    case pipFemale = "CNPipFemaleViewController"
    case alertAdsDeactivated = "CNAlertAdsDeativatedViewController"
    case alertAdsDeactivatedTY = "CNAlertAdsDeativatedTYViewController"
}

extension UIStoryboard {

    class func load(_ storyboard: StoryBoardName = .main, controller: ControllerName) -> UIViewController {
        let st = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        return st.instantiateViewController(withIdentifier: controller.rawValue)
    }
    
    class func load(_ storyboard: StoryBoardName = .main) -> UIViewController? {
        return UIStoryboard(name: storyboard.rawValue, bundle: nil).instantiateInitialViewController()
    }
    
}
