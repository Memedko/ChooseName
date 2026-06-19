//
//  Constants.swift
//  ChooseName
//
//  Created by Inna Levandovskaya on 13.12.2020.
//

import Foundation
import UIKit

class Constants {
    static let isProd = true
    
    static let shownIntro = "shownIntro"
    static let savedMaleLastName = "savedLastNameBoy"
    static let savedMaleFatherName = "savedFatherNameBoy"
    static let savedFemaleLastName = "savedLastNameGirl"
    static let savedFemaleFatherName = "savedFatherNameGirl"
    static let shownCardsCount = "shownCardsCount"
    static let shownCardstLimit = 12
    static let isMaleSelected = "isMaleSelected"
    
    static let notificationUpdateSavedNames = "notificationUpdateSavedNames"
    static let notificationUpdateUserData = "notificationUpdateUserData"
    
    static let userDataSex = "userDataSex"
    static let userDataLastName = "userDataLastName"
    static let userDataFathersName = "userDataFathersName"
    static let userDataBirthdayDay = "userDataBirthdayDay"
    static let userDataBirthdayMonth = "userDataBirthdayMonth"
    
    static let nameKeyNameID = "nameID"
    static let nameKeyName = "name"
    static let nameKeySelect = "select"
    static let nameKeyVersions = "versions"
    static let nameKeyValue = "description"
    static let nameKeyDescription = "descriptionName"
    static let nameKeyDays = "nameDays"
    static let nameKeyTrans = "transliteration"
    static let nameKeyEng = "name_en"
    static let nameKeyRu = "name_ru"
    static let nameKeyCelebrities = "celebrities"
    static let nameKeyCharacters = "characters"
    static let nameKeyCelebritieUrl = "url"
    static let nameKeyCelebritiePhoto = "imgUrl"
    static let nameKeyCelebritieDescription = "description"
    static let nameKeyCelebrityDescriptionDB = "descriptionCelebrity"
    static let nameKeyCharacterDescriptionDB = "descriptionCharacter"
    static let nameKeyCelebritieSort = "sort"
    static let nameKeySongss = "songs"
    static let nameKeySongTitle = "title"
    static let nameKeySongSinger = "singer"
    static let nameKeySongUrl = "url"
    static let nameKeyLiked = "liked"
    static let nameKeySame = "sameNames"
    static let nameKeyLangs = "langs"
    static let nameKeyChildren = "children"
    static let nameKeyChildName = "name"
    static let nameKeyChildParents = "parents"
    static let nameKeyChildBirthday = "birthday"
    static let nameKeyChildDeath = "yearOfDeath"
    static let nameKeyChildSort = "sort"
    
    static let nameLimit = 50
    
    static let cellName = "cellName"
    static let cellLastName = "cellLastName"
    static let cellInitialsTitle = "cellInitialsTitle"
    static let cellInitials = "cellInitials"
    static let cellVersionsTitle = "cellVersionsTitle"
    static let cellVersions = "cellVersions"
    static let cellDescriptionTitle = "cellDescriptionTitle"
    static let cellDescription = "cellDescription"
    static let cellRuTitle = "cellRuTitle"
    static let cellRu = "cellRu"
    static let cellEnTitle = "cellEnTitle"
    static let cellEn = "cellEn"
    static let cellDaysTitle = "cellDaysTitle"
    static let cellDays = "cellDays"
    static let cellCelebritiesTitle = "cellCelebritiesTitle"
    static let cellCharactersTitle = "cellCharactersTitle"
    static let cellCelebrity = "cellCelebrity"
    static let cellCharacters = "cellCharacters"
    static let cellSongsTitle = "cellSongsTitle"
    static let cellSong = "cellSong"
    static let cellChildrenTitle = "cellChildrenTitle"
    static let cellChild = "cellChild"
    static let cellSameTitle = "cellSameTitle"
    static let cellSame = "cellSame"
    static let cellLangsTitle = "cellLangsTitle"
    static let cellLangs = "cellLangs"
    
    //MARK: Fonts
    
    static func fontRegular(_ size:CGFloat) -> UIFont {
        return UIFont.init(name: "MontserratAlternates", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    static func fontBold(_ size:CGFloat) -> UIFont {
        return UIFont.init(name: "MontserratAlternates-Bold", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
