//
//  Models.swift
//  ChooseName
//
//  Created by Inna Levandovskaya on 22.12.2020.
//

import Foundation
import CoreData

public enum GenderType: String {
    case male = "male", female = "female"
}

public struct Name {
    var nameID: String?
    var name: String?
    var vesions: String?
    var days: String?
    var value: String?
    var nameEng: String?
    var nameRu: String?
    var nameTrans: String?
    var celebrities: [Celebrity] = []
    var songs: [Song] = []
    var characters: [Сharacter] = []
    var children: [Child] = []
    var select:Int = 0
    var isLiked:Bool = false
    var sameNames: String?
    var langs: String?
    
    mutating func updateFromData(_ data:[String:Any]) {
        nameID = data[Constants.nameKeyNameID] as? String
        select = 0
        isLiked = false
        
        if let _name = data[Constants.nameKeyName] as? String {
            name = _name
        }
        if let _vesions = data[Constants.nameKeyVersions] as? String {
            vesions = _vesions
        }
        if let _days = data[Constants.nameKeyDays] as? String {
            days = _days
        }
        if let _value = data[Constants.nameKeyValue] as? String {
            value = _value
        }
        if let _nameTrans = data[Constants.nameKeyTrans] as? String {
            nameTrans = _nameTrans
        }
        if let _nameEng = data[Constants.nameKeyEng] as? String {
            nameEng = _nameEng
        }
        if let _nameRu = data[Constants.nameKeyRu] as? String {
            nameRu = _nameRu
        }
        if let _celebrities = data[Constants.nameKeyCelebrities] as? [[String:Any]] {
            var tempCelebs:[Celebrity] = []
            for item in _celebrities {
                var celebrity = Celebrity.init()
                celebrity.updateFromData(item)
                tempCelebs.append(celebrity)
            }
            celebrities = tempCelebs.sorted{$0.sort > $1.sort}
        }
        if let _сharacters = data[Constants.nameKeyCharacters] as? [[String:Any]] {
            var tempCharacters:[Сharacter] = []
            for item in _сharacters {
                var character = Сharacter.init()
                character.updateFromData(item)
                tempCharacters.append(character)
            }
            characters = tempCharacters.sorted{$0.sort > $1.sort}
        }
        if let _songs = data[Constants.nameKeySongss] as? [[String:Any]] {
            var tempSongs:[Song] = []
            for item in _songs {
                var song = Song.init()
                song.updateFromData(item)
                tempSongs.append(song)
            }
            songs = tempSongs.sorted{$0.sort > $1.sort}
        }
        if let _same = data[Constants.nameKeySame] as? String {
            sameNames = _same
        }
        if let _langs = data[Constants.nameKeyLangs] as? String {
            langs = _langs
        }
        if let _children = data[Constants.nameKeyChildren] as? [[String:Any]] {
            var tempChildren:[Child] = []
            for item in _children {
                var child = Child.init()
                child.updateFromData(item)
                tempChildren.append(child)
            }
            children = tempChildren.sorted{$0.sort > $1.sort}
        }
    }
    
    mutating func updateFromData(_ data:NSManagedObject) {
        nameID = data.value(forKey: Constants.nameKeyNameID) as? String ?? ""
        select = data.value(forKey: Constants.nameKeySelect) as? Int ?? 0
        isLiked = data.value(forKey: Constants.nameKeyLiked) as? Bool ?? false
        
        if let _name = data.value(forKey: Constants.nameKeyName) as? String {
            name = _name
        }
        if let _vesions = data.value(forKey: Constants.nameKeyVersions) as? String {
            vesions = _vesions
        }
        if let _days = data.value(forKey: Constants.nameKeyDays) as? String {
            days = _days
        }
        if let _value = data.value(forKey: Constants.nameKeyDescription) as? String {
            value = _value
        }
        if let _nameTrans = data.value(forKey: Constants.nameKeyTrans) as? String {
            nameTrans = _nameTrans
        }
        if let _nameEng = data.value(forKey: Constants.nameKeyEng) as? String {
            nameEng = _nameEng
        }
        if let _nameRu = data.value(forKey: Constants.nameKeyRu) as? String {
            nameRu = _nameRu
        }
        var result =  self
        DataSource.instance.getCelebrities(nameID!) { (celebrityData) in
            var tempCelebs:[Celebrity] = []
            for item in celebrityData {
                var celebrity = Celebrity.init()
                celebrity.updateFromData(item)
                tempCelebs.append(celebrity)
            }
            result.celebrities = tempCelebs
        }
        DataSource.instance.getCharacters(nameID!) { (characterData) in
            var tempCharacters:[Сharacter] = []
            for item in characterData {
                var character = Сharacter.init()
                character.updateFromData(item)
                tempCharacters.append(character)
            }
            result.characters = tempCharacters
        }
        DataSource.instance.getSongs(nameID!) { (songData) in
            var tempSongs:[Song] = []
            for item in songData {
                var song = Song.init()
                song.updateFromData(item)
                tempSongs.append(song)
            }
            result.songs = tempSongs
        }
        DataSource.instance.getChildren(nameID!) { (childrenData) in
            var tempChildren:[Child] = []
            for item in childrenData {
                var child = Child.init()
                child.updateFromData(item)
                tempChildren.append(child)
            }
            result.children = tempChildren
        }
        if let _same = data.value(forKey: Constants.nameKeySame) as? String {
            result.sameNames = _same
        }
        if let _langs = data.value(forKey: Constants.nameKeyLangs) as? String {
            result.langs = _langs
        }
        self = result
    }
    
}

public struct Celebrity {
    var name: String?
    var url: String?
    var photo: String?
    var description: String?
    var sort:Int = 0
    
    mutating func updateFromData(_ data:[String:Any]) {
        name = data[Constants.nameKeyName] as? String ?? ""
        url = data[Constants.nameKeyCelebritieUrl] as? String
        photo = data[Constants.nameKeyCelebritiePhoto] as? String
        description = data[Constants.nameKeyCelebritieDescription] as? String
        sort = data[Constants.nameKeyCelebritieSort] as? Int ?? 0
    }
    
    mutating func updateFromData(_ data:NSManagedObject) {
        name = data.value(forKey: Constants.nameKeyName) as? String ?? ""
        url = data.value(forKey: Constants.nameKeyCelebritieUrl) as? String
        photo = data.value(forKey: Constants.nameKeyCelebritiePhoto) as? String
        description = data.value(forKey: Constants.nameKeyCelebrityDescriptionDB) as? String
        sort = data.value(forKey: Constants.nameKeyCelebritieSort) as? Int ?? 0
    }

}

public struct Сharacter {
    var name: String?
    var url: String?
    var photo: String?
    var description: String?
    var sort:Int = 0
    
    mutating func updateFromData(_ data:[String:Any]) {
        name = data[Constants.nameKeyName] as? String ?? ""
        url = data[Constants.nameKeyCelebritieUrl] as? String
        photo = data[Constants.nameKeyCelebritiePhoto] as? String
        description = data[Constants.nameKeyCelebritieDescription] as? String
        sort = data[Constants.nameKeyCelebritieSort] as? Int ?? 0
    }
    
    mutating func updateFromData(_ data:NSManagedObject) {
        name = data.value(forKey: Constants.nameKeyName) as? String ?? ""
        url = data.value(forKey: Constants.nameKeyCelebritieUrl) as? String
        photo = data.value(forKey: Constants.nameKeyCelebritiePhoto) as? String
        description = data.value(forKey: Constants.nameKeyCharacterDescriptionDB) as? String
        sort = data.value(forKey: Constants.nameKeyCelebritieSort) as? Int ?? 0
    }
}

public struct Song {
    var title: String?
    var singer: String?
    var url: String?
    var sort:Int = 0
    
    mutating func updateFromData(_ data:[String:Any]) {
        title = data[Constants.nameKeySongTitle] as? String ?? ""
        singer = data[Constants.nameKeySongSinger] as? String
        url = data[Constants.nameKeySongUrl] as? String
        sort = data[Constants.nameKeyCelebritieSort] as? Int ?? 0
    }
    
    mutating func updateFromData(_ data:NSManagedObject) {
        title = data.value(forKey: Constants.nameKeySongTitle) as? String ?? ""
        singer = data.value(forKey: Constants.nameKeySongSinger) as? String ?? ""
        url = data.value(forKey: Constants.nameKeySongUrl) as? String
        sort = data.value(forKey: Constants.nameKeyCelebritieSort) as? Int ?? 0
    }
}

public struct Child {
    var name: String?
    var parents: String?
    var birthday: Int = 0
    var yearOfDeath:Int = 0
    var sort:Int = 0
    
    mutating func updateFromData(_ data:[String:Any]) {
        name = data[Constants.nameKeyChildName] as? String ?? ""
        parents = data[Constants.nameKeyChildParents] as? String
        birthday = data[Constants.nameKeyChildBirthday] as? Int ?? 0
        yearOfDeath = data[Constants.nameKeyChildDeath] as? Int ?? 0
        sort = data[Constants.nameKeyChildSort] as? Int ?? 0
    }
    
    mutating func updateFromData(_ data:NSManagedObject) {
        name = data.value(forKey: Constants.nameKeyChildName) as? String ?? ""
        parents = data.value(forKey: Constants.nameKeyChildParents) as? String ?? ""
        birthday = data.value(forKey: Constants.nameKeyChildBirthday) as? Int ?? 0
        yearOfDeath = data.value(forKey: "death") as? Int ?? 0
        sort = data.value(forKey: Constants.nameKeyChildSort) as? Int ?? 0
    }
}
