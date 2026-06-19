//
//  DataSource.swift
//  ChooseName
//
//  Created by Inna Levandovskaya on 22.12.2020.
//

import UIKit
import Foundation
import CoreData

class DataSource: NSObject {
    var persistentContainer:NSPersistentContainer?
    
    @objc static let instance:DataSource = {
        let instance = DataSource()
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            instance.persistentContainer = appDelegate.persistentContainer
        }
        return instance
    }()
    
    func updateDB() {
//        cleableDrTableDB("CNNameMale")
//        clearTaB("CNNameFemale")
//
//        self.clearTableDB("CNCelebrity")
//        self.clearTableDB("CNCharacter")
//        self.clearTableDB("CNSong")
        HttpService.instance.setupListeners()
    }
    
    func getNames(_ isMale:Bool, callblock block: @escaping (_ names:[Name], _ error:String?) -> ()) {
        getNamesDB(isMale) { (names) in
            if isMale == false {
                print("female")
            }
            if names.count > 0 {
                block(names, nil)
            } else {
//                self.clearTableDB("CNCelebrity")
//                self.clearTableDB("CNCharacter")
//                self.clearTableDB("CNSong")
                self.downloadNames(isMale) { (names) in
                    if names.count == 0 {
                        self.getNamesDB(isMale) { (names) in
                            block(names, nil)
                        }
                    } else {
                        block(names, nil)
                    }
                }
            }
        }
    }
    
    func handleData(_ data:[[String:Any]]?) -> [Name] {
        if let data = data {
            var names:[Name] = []
            for item in data {
                var name = Name.init()
                name.updateFromData(item)
                names.append(name)
            }
            return names
        } else {
            return []
        }
    }
    
    func handleData(_ data:[NSManagedObject]?) -> [Name] {
        if let data = data {
            var names:[Name] = []
            for item in data {
                var name = Name.init()
                name.updateFromData(item)
                names.append(name)
            }
            return names
        } else {
            return []
        }
    }
    
    func getSearchResult(isMale:Bool, search:String, callblock block: @escaping (_ names:[Name], _ error:String?) -> ()) {
        let tableName = isMale ? "CNNameMale" : "CNNameFemale"
        if let managedContext = self.persistentContainer?.viewContext {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: tableName)
//            fetchRequest.predicate = NSPredicate(format: "((name BEGINSWITH[c] %@) OR (versions CONTAINS %@)) AND select == 0", search, search)
            fetchRequest.predicate = NSPredicate(format: "(name BEGINSWITH[c] %@) OR (versions CONTAINS %@)", search, search)
            do {
                let names = try managedContext.fetch(fetchRequest)
                block(self.handleData(names), nil)
            } catch let error as NSError {
                print("Error: %@", error.localizedDescription)
                block([], "Something is wrong. Please try again.".localized())
            }
        } else {
            block([], "Something is wrong. Please try again.".localized())
        }
    }
    
    func getSearchEqualResult(isMale:Bool, search:String, callblock block: @escaping (_ names:Name?) -> ()) {
        let tableName = isMale ? "CNNameMale" : "CNNameFemale"
        if let managedContext = self.persistentContainer?.viewContext {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: tableName)
            fetchRequest.predicate = NSPredicate(format: "(name == %@)", search)
            do {
                let names = try managedContext.fetch(fetchRequest)
                if let name = self.handleData(names).first {
                    block(name)
                } else {
                    block(nil)
                }
            } catch let error as NSError {
                print("Error: %@", error.localizedDescription)
                block(nil)
            }
        } else {
            block(nil)
        }
    }
    
    func getCelebrities(_ nameID:String, callblock block: @escaping (_ celebrities:[NSManagedObject]) -> ()) {
        if let managedContext = self.persistentContainer?.viewContext {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CNCelebrity")
            fetchRequest.predicate = NSPredicate(format: "nameID == %@", nameID)
            fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath:\CNCelebrity.sort, ascending: false)]
            do {
                let celebrities = try managedContext.fetch(fetchRequest)
                block(celebrities)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
                block([])
            }
        } else {
            block([])
        }
    }
    
    func getCharacters(_ nameID:String, callblock block: @escaping (_ characters:[NSManagedObject]) -> ()) {
        if let managedContext = self.persistentContainer?.viewContext {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CNCharacter")
            fetchRequest.predicate = NSPredicate(format: "nameID == %@", nameID)
            fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath:\CNCharacter.sort, ascending: false)]
            do {
                let characters = try managedContext.fetch(fetchRequest)
                block(characters)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
                block([])
            }
        } else {
            block([])
        }
    }
    
    func getSongs(_ nameID:String, callblock block: @escaping (_ characters:[NSManagedObject]) -> ()) {
        if let managedContext = self.persistentContainer?.viewContext {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CNSong")
            fetchRequest.predicate = NSPredicate(format: "nameID == %@", nameID)
            fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath:\CNSong.sort, ascending: false)]
            do {
                let characters = try managedContext.fetch(fetchRequest)
                block(characters)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
                block([])
            }
        } else {
            block([])
        }
    }
    
    func getChildren(_ nameID:String, callblock block: @escaping (_ characters:[NSManagedObject]) -> ()) {
        if let managedContext = self.persistentContainer?.viewContext {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CNChild")
            fetchRequest.predicate = NSPredicate(format: "nameID == %@", nameID)
            fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath:\CNSong.sort, ascending: false)]
            do {
                let children = try managedContext.fetch(fetchRequest)
                block(children)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
                block([])
            }
        } else {
            block([])
        }
    }
    
    func saveContext () {
        if let context = self.persistentContainer?.viewContext {
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
    
    func addNameDB(_ name: Name, _ isMale: Bool) {
        let tableName = isMale ? "CNNameMale" : "CNNameFemale"
        if let managedContext = self.persistentContainer?.viewContext {
            let entity = NSEntityDescription.entity(forEntityName: tableName, in: managedContext)!
            let model = NSManagedObject(entity: entity, insertInto: managedContext)
            model.setValue(name.nameID, forKeyPath: "nameID")
            model.setValue(name.name, forKeyPath: "name")
            model.setValue(name.value, forKeyPath: "descriptionName")
            model.setValue(name.nameEng, forKeyPath: "name_en")
            model.setValue(name.nameRu, forKeyPath: "name_ru")
            model.setValue(name.nameTrans, forKeyPath: "transliteration")
            model.setValue(name.days, forKeyPath: "nameDays")
            model.setValue(name.vesions, forKeyPath: "versions")
            if let same = name.sameNames, same.count > 0 {
                model.setValue(name.sameNames, forKeyPath: "sameNames")
            }
            if let langs = name.langs, langs.count > 0 {
                model.setValue(name.langs, forKeyPath: "langs")
            }
            self.saveContext()
            removeCelebrities(name.nameID!, managedContext)
            if name.celebrities.count > 0 {
                addCelebrities(name.celebrities, name.nameID!, managedContext)
            }
            removeСharacters(name.nameID!, managedContext)
            if name.characters.count > 0 {
                addNameCharacters(name.characters, name.nameID!, managedContext)
            }
            removeSongs(name.nameID!, managedContext)
            if name.songs.count > 0 {
                addSongs(name.songs, name.nameID!, managedContext)
            }
            removeChildren(name.nameID!, managedContext)
            if name.children.count > 0 {
                addChildren(name.children, name.nameID!, managedContext)
            }
        }
    }
    
    func updateNameBD(_ name: Name, _ isMale: Bool) {
        let tableName = isMale ? "CNNameMale" : "CNNameFemale"
        if let managedContext = self.persistentContainer?.viewContext {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: tableName)
            fetchRequest.predicate = NSPredicate(format: "nameID == %@", name.nameID!)
            do {
                let names = try managedContext.fetch(fetchRequest)
                if names.count > 0 {
                    let model = names.first
                    model?.setValue(name.nameID, forKeyPath: "nameID")
                    model?.setValue(name.name, forKeyPath: "name")
                    model?.setValue(name.value, forKeyPath: "descriptionName")
                    model?.setValue(name.nameEng, forKeyPath: "name_en")
                    model?.setValue(name.nameRu, forKeyPath: "name_ru")
                    model?.setValue(name.nameTrans, forKeyPath: "transliteration")
                    model?.setValue(name.days, forKeyPath: "nameDays")
                    model?.setValue(name.vesions, forKeyPath: "versions")
                    if let same = name.sameNames, same.count > 0 {
                        model?.setValue(name.sameNames, forKeyPath: "sameNames")
                    }
                    if let langs = name.langs, langs.count > 0 {
                        model?.setValue(name.langs, forKeyPath: "langs")
                    }
                    self.saveContext()
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            
            //Celebrities
            removeCelebrities(name.nameID!, managedContext)
            if name.celebrities.count > 0 {
                addCelebrities(name.celebrities, name.nameID!, managedContext)
            }
            
            //Characters
            removeСharacters(name.nameID!, managedContext)
            if name.characters.count > 0 {
                addNameCharacters(name.characters, name.nameID!, managedContext)
            }
            
            //Songs
            removeSongs(name.nameID!, managedContext)
            if name.songs.count > 0 {
                addSongs(name.songs, name.nameID!, managedContext)
            }
            
            //Children
            removeChildren(name.nameID!, managedContext)
            if name.children.count > 0 {
                addChildren(name.children, name.nameID!, managedContext)
            }
        }
        let nameData:[String:String] = ["nameID": name.nameID!]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateName"), object: nil, userInfo: nameData)
    }
    
    func updateUnlikedNamesBD(_ isMale: Bool) {
        let tableName = isMale ? "CNNameMale" : "CNNameFemale"
        if let managedContext = self.persistentContainer?.viewContext {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: tableName)
            fetchRequest.predicate = NSPredicate(format: "select == -1")
            do {
                let names = try managedContext.fetch(fetchRequest)
                if names.count > 0 {
                    for name in names {
                        name.setValue(0, forKeyPath: "select")
                    }
                    self.saveContext()
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func addCelebrities(_ celebrities:[Celebrity], _ nameID:String, _ managedContext:NSManagedObjectContext) {
        for celeb in celebrities {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CNCelebrity")
            fetchRequest.predicate = NSPredicate(format: "name == %@", celeb.name!)
            do {
                let names = try managedContext.fetch(fetchRequest)
                if names.count == 0 {
                    let entityCeleb = NSEntityDescription.entity(forEntityName: "CNCelebrity", in: managedContext)!
                    let modelCeleb = NSManagedObject(entity: entityCeleb, insertInto: managedContext)
                    modelCeleb.setValue(celeb.name, forKeyPath: "name")
                    modelCeleb.setValue(celeb.description, forKeyPath: "descriptionCelebrity")
                    modelCeleb.setValue(celeb.url, forKeyPath: "url")
                    modelCeleb.setValue(celeb.photo, forKeyPath: "imgUrl")
                    modelCeleb.setValue(celeb.sort, forKeyPath: "sort")
                    modelCeleb.setValue(nameID, forKeyPath: "nameID")
                    self.saveContext()
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func removeCelebrities(_ nameID:String, _ managedContext:NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CNCelebrity")
        fetchRequest.predicate = NSPredicate(format: "nameID == %@", nameID)
        do {
            let celebs = try managedContext.fetch(fetchRequest)
            for celeb in celebs {
                managedContext.delete(celeb)
            }
            self.saveContext()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func addNameCharacters(_ characters:[Сharacter], _ nameID:String, _ managedContext:NSManagedObjectContext) {
        for character in characters {
            let entityCharacter = NSEntityDescription.entity(forEntityName: "CNCharacter", in: managedContext)!
            let modelCharacter = NSManagedObject(entity: entityCharacter, insertInto: managedContext)
            modelCharacter.setValue(character.name, forKeyPath: "name")
            modelCharacter.setValue(character.description, forKeyPath: "descriptionCharacter")
            modelCharacter.setValue(character.url, forKeyPath: "url")
            modelCharacter.setValue(character.photo, forKeyPath: "imgUrl")
            modelCharacter.setValue(character.sort, forKeyPath: "sort")
            modelCharacter.setValue(nameID, forKeyPath: "nameID")
            self.saveContext()
        }
    }
    
    func removeСharacters(_ nameID:String, _ managedContext:NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CNCharacter")
        fetchRequest.predicate = NSPredicate(format: "nameID == %@", nameID)
        do {
            let characters = try managedContext.fetch(fetchRequest)
            for character in characters {
                managedContext.delete(character)
            }
            self.saveContext()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func addSongs(_ songs:[Song], _ nameID:String, _ managedContext:NSManagedObjectContext) {
        for song in songs {
            let entitySong = NSEntityDescription.entity(forEntityName: "CNSong", in: managedContext)!
            let modelSong = NSManagedObject(entity: entitySong, insertInto: managedContext)
            modelSong.setValue(song.title, forKeyPath: "title")
            modelSong.setValue(song.singer, forKeyPath: "singer")
            modelSong.setValue(song.url, forKeyPath: "url")
            modelSong.setValue(song.sort, forKeyPath: "sort")
            modelSong.setValue(nameID, forKeyPath: "nameID")
            self.saveContext()
        }
    }
    
    func removeSongs(_ nameID:String, _ managedContext:NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CNSong")
        fetchRequest.predicate = NSPredicate(format: "nameID == %@", nameID)
        do {
            let songs = try managedContext.fetch(fetchRequest)
            for song in songs {
                managedContext.delete(song)
            }
            self.saveContext()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func addChildren(_ children:[Child], _ nameID:String, _ managedContext:NSManagedObjectContext) {
        for child in children {
            let entityChild = NSEntityDescription.entity(forEntityName: "CNChild", in: managedContext)!
            let modelChild = NSManagedObject(entity: entityChild, insertInto: managedContext)
            modelChild.setValue(child.name, forKeyPath: "name")
            modelChild.setValue(child.parents, forKeyPath: "parents")
            modelChild.setValue(child.birthday, forKeyPath: "birthday")
            modelChild.setValue(child.yearOfDeath, forKeyPath: "death")
            modelChild.setValue(child.sort, forKeyPath: "sort")
            modelChild.setValue(nameID, forKeyPath: "nameID")
            self.saveContext()
        }
    }
    
    func removeChildren(_ nameID:String, _ managedContext:NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CNChild")
        fetchRequest.predicate = NSPredicate(format: "nameID == %@", nameID)
        do {
            let children = try managedContext.fetch(fetchRequest)
            for child in children {
                managedContext.delete(child)
            }
            self.saveContext()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func getNamesDB(_ isMale:Bool, callblock block: @escaping (_ names:[Name]) -> ()) {
        if let managedContext = self.persistentContainer?.viewContext {
            let tableName = isMale ? "CNNameMale" : "CNNameFemale"
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: tableName)
            fetchRequest.predicate = NSPredicate(format: "(select != 1) AND (select != -1)")
            do {
                let names = try managedContext.fetch(fetchRequest)
                block(self.handleData(names))
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
                block([])
            }
        } else {
            print("Error: can't fetch data frome Core Data DB.")
            block([])
        }
    }
    
    func getNameDB(_ nameID:String, _ isMale:Bool, callblock block: @escaping (_ name:Name?) -> ()) {
        if let managedContext = self.persistentContainer?.viewContext {
            let tableName = isMale ? "CNNameMale" : "CNNameFemale"
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: tableName)
            fetchRequest.predicate = NSPredicate(format: "nameID == %@", nameID)
            do {
                let names = try managedContext.fetch(fetchRequest)
                block(self.handleData(names).first)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
                block(nil)
            }
        } else {
            print("Error: can't fetch data frome Core Data DB.")
            block(nil)
        }
    }
    
    func downloadNames(_ isMale:Bool, callblock block: @escaping (_ names:[Name]) -> ()) {
        if isMale {
            HttpService.instance.getMaleNames { (data, error) in
                var nameListData:[[String:Any]] = []
                if let dataNames = data, dataNames.count > 0 {
                    for dataName in dataNames {
                        if let dataID = dataName[Constants.nameKeyNameID] as? String {
                            if self.checkName(dataID, dataName, isMale) {
                                nameListData.append(dataName)
                            }
                        }
                    }
                }
                let nameList:[Name] = nameListData.count > 0 ? self.handleData(nameListData) : []
                block(nameList)
            }
        } else {
            HttpService.instance.getFemaleNames { (data, error) in
                var nameListData:[[String:Any]] = []
                if let dataNames = data, dataNames.count > 0 {
                    for dataName in dataNames {
                        if let dataID = dataName[Constants.nameKeyNameID] as? String {
                            if self.checkName(dataID, dataName, isMale) {
                                nameListData.append(dataName)
                            }
                        }
                    }
                }
                let nameList:[Name] = nameListData.count > 0 ? self.handleData(nameListData) : []
                block(nameList)
            }
        }
    }
    
    func clearTableDB(_ tableName:String) {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: tableName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        if let managedContext = self.persistentContainer?.viewContext {
            do {
                try managedContext.execute(deleteRequest)
            } catch let error as NSError {
                print("Error: ", error.localizedDescription)
            }
            self.saveContext()
        }
    }
    
    func clearAllDB() {
        clearTableDB("CNNameMale")
        clearTableDB("CNNameFemale")
        clearTableDB("CNCelebrity")
        clearTableDB("CNCharacter")
        clearTableDB("CNSong")
        HttpService.instance.setupListeners()
    }
    
    func checkName(_ nameID:String, _ data:[String:Any], _ isMale:Bool) -> Bool {
        if let managedContext = self.persistentContainer?.viewContext {
            let tableName = isMale ? "CNNameMale" : "CNNameFemale"
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: tableName)
            fetchRequest.predicate = NSPredicate(format: "nameID == %@", nameID)
            do {
                let names = try managedContext.fetch(fetchRequest)
                if names.count == 0 {
                    var nameData = data
                    nameData[Constants.nameKeyNameID] = nameID
                    let convertedNames = handleData([nameData])
                    if let convertedName = convertedNames.first {
                        addNameDB(convertedName, isMale)
                        return true
                    }
                }
                return false
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
                return false
            }
        }
        return false
    }
    
    func editName(_ nameID:String, _ data:[String:Any], _ isMale:Bool) {
        if let managedContext = self.persistentContainer?.viewContext {
            let tableName = isMale ? "CNNameMale" : "CNNameFemale"
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: tableName)
            fetchRequest.predicate = NSPredicate(format: "nameID == %@", nameID)
            var nameData = data
            nameData[Constants.nameKeyNameID] = nameID
            let convertedNames = handleData([nameData])
            do {
                let names = try managedContext.fetch(fetchRequest)
                if names.count == 0 {
                    if let convertedName = convertedNames.first {
                        addNameDB(convertedName, isMale)
                    }
                } else {
                    updateNameBD(convertedNames.first!, isMale)
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func removeName(_ nameID:String, _ isMale:Bool) {
        if let managedContext = self.persistentContainer?.viewContext {
            let tableName = isMale ? "CNNameMale" : "CNNameFemale"
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: tableName)
            fetchRequest.predicate = NSPredicate(format: "nameID == %@", nameID)
            do {
                let celebs = try managedContext.fetch(fetchRequest)
                for celeb in celebs {
                    managedContext.delete(celeb)
                }
                self.saveContext()
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func likeName(_ nameID: String, _ isMale:Bool) {
        if let managedContext = self.persistentContainer?.viewContext {
            let tableName = isMale ? "CNNameMale" : "CNNameFemale"
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: tableName)
            fetchRequest.predicate = NSPredicate(format: "nameID == %@", nameID)
            do {
                let names = try managedContext.fetch(fetchRequest)
                if let selectedName = names.first {
                    selectedName.setValue(1, forKeyPath: "select")
                    selectedName.setValue(false, forKeyPath: "liked")
                    self.saveContext()
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func unlikeName(_ nameID: String, _ isMale:Bool) {
        if let managedContext = self.persistentContainer?.viewContext {
            let tableName = isMale ? "CNNameMale" : "CNNameFemale"
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: tableName)
            fetchRequest.predicate = NSPredicate(format: "nameID == %@", nameID)
            do {
                let names = try managedContext.fetch(fetchRequest)
                if let selectedName = names.first {
                    selectedName.setValue(0, forKeyPath: "select")
                    selectedName.setValue(false, forKeyPath: "liked")
                    self.saveContext()
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func dislikeName(_ nameID: String, _ isMale:Bool) {
        if let managedContext = self.persistentContainer?.viewContext {
            let tableName = isMale ? "CNNameMale" : "CNNameFemale"
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: tableName)
            fetchRequest.predicate = NSPredicate(format: "nameID == %@", nameID)
            do {
                let names = try managedContext.fetch(fetchRequest)
                if let selectedName = names.first {
                    selectedName.setValue(-1, forKeyPath: "select")
                    selectedName.setValue(false, forKeyPath: "liked")
                    self.saveContext()
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func getLikedNames(_ isMale:Bool, callblock block: @escaping (_ names:[Name]) -> ()) {
        if let managedContext = self.persistentContainer?.viewContext {
            let tableName = isMale ? "CNNameMale" : "CNNameFemale"
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: tableName)
            fetchRequest.predicate = NSPredicate(format: "select == 1")
            do {
                let names = try managedContext.fetch(fetchRequest)
                block(self.handleData(names))
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
                block([])
            }
        } else {
            print("Error: can't fetch data frome Core Data DB.")
            block([])
        }
    }
    
    func selectLikedName(_ nameID:String, _ isMale: Bool) {
        if let managedContext = self.persistentContainer?.viewContext {
            let tableName = isMale ? "CNNameMale" : "CNNameFemale"
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: tableName)
            fetchRequest.predicate = NSPredicate(format: "select == 1")
            do {
                let names = try managedContext.fetch(fetchRequest)
                if names.count > 0 {
                    for name in names {
                        name.setValue(false, forKeyPath: "liked")
                        if name.value(forKey: "nameID") as? String ?? "" == nameID {
                            name.setValue(true, forKeyPath: "liked")
                            if let nameValue = name.value(forKey: "name") as? String {
                                HttpService.instance.saveFavoriteName(nameValue, isMale)
                            }
                        }
                    }
                    self.saveContext()
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        } else {
            print("Error: can't fetch data frome Core Data DB.")
        }
    }
    
    func unselectLikedName(_ nameID:String, _ isMale: Bool) {
        if let managedContext = self.persistentContainer?.viewContext {
            let tableName = isMale ? "CNNameMale" : "CNNameFemale"
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: tableName)
            fetchRequest.predicate = NSPredicate(format: "nameID == %@", nameID)
            do {
                let names = try managedContext.fetch(fetchRequest)
                if let name = names.first {
                    name.setValue(false, forKeyPath: "liked")
                    self.saveContext()
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        } else {
            print("Error: can't fetch data frome Core Data DB.")
        }
    }
    
    func searchForAdding(_ text:String, _ isMale:Bool, callblock block: @escaping (_ names:[Name]) -> ()) {
        if let managedContext = self.persistentContainer?.viewContext {
            let tableName = isMale ? "CNNameMale" : "CNNameFemale"
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: tableName)
            fetchRequest.predicate = NSPredicate(format: "name BEGINSWITH[c] %@", text)
            do {
                let names = try managedContext.fetch(fetchRequest)
                block(handleData(names))
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        } else {
            print("Error: can't fetch data frome Core Data DB.")
        }
    }
    
    func checkNameDB(_ name:String, _ isMale:Bool, callblock block: @escaping (_ name:Name?) -> ()) {
        if let managedContext = self.persistentContainer?.viewContext {
            let tableName = isMale ? "CNNameMale" : "CNNameFemale"
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: tableName)
            fetchRequest.predicate = NSPredicate(format: "name == %@", name)
            do {
                let names = try managedContext.fetch(fetchRequest)
                block(self.handleData(names).first)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
                block(nil)
            }
        } else {
            print("Error: can't fetch data frome Core Data DB.")
            block(nil)
        }
    }
    
    func addNewNameDB(_ name:String, _ isMale:Bool) {
        if let managedContext = self.persistentContainer?.viewContext {
            let tableName = isMale ? "CNNameMale" : "CNNameFemale"
            let entity = NSEntityDescription.entity(forEntityName: tableName, in: managedContext)!
            let model = NSManagedObject(entity: entity, insertInto: managedContext)
            model.setValue(name, forKeyPath: "name")
            model.setValue(1, forKeyPath: "select")
            self.saveContext()
            HttpService.instance.saveCustomName(name, isMale)
        } else {
            print("Error: can't fetch data frome Core Data DB.")
        }
    }
    
    func removeNewNameDB(_ name:String, _ isMale:Bool) {
        if let managedContext = self.persistentContainer?.viewContext {
            let tableName = isMale ? "CNNameMale" : "CNNameFemale"
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: tableName)
            fetchRequest.predicate = NSPredicate(format: "name == %@", name)
            do {
                let names = try managedContext.fetch(fetchRequest)
                for name in names {
                    managedContext.delete(name)
                }
                self.saveContext()
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
}
