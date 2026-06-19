//
//  HttpService.swift
//  ChooseName
//
//  Created by Inna Levandovskaya on 24.12.2020.
//

import Foundation
import Firebase
import UIKit

class HttpService: NSObject {
    private let db = Firestore.firestore()
    
    static let instance : HttpService = {
        let instance = HttpService()
        return instance
    }()
    
    func getMaleNames(callblock block: @escaping (_ data:[[String:Any]]?, _ error:String?) -> ()) {
        db.collection("maleNames").limit(to: 400).getDocuments() { (querySnapshot, error) in
            self.handleNameList(querySnapshot, error) { (data, error) in
                block(data, error)
            }
        }
    }
    
    func getFemaleNames(callblock block: @escaping (_ data:[[String:Any]]?, _ error:String?) -> ()) {
        db.collection("femaleNames").limit(to: 400).getDocuments() { (querySnapshot, error) in
            self.handleNameList(querySnapshot, error) { (data, error) in
                block(data, error)
            }
        }
    }
    
    func setupListeners() {
        db.collection("maleNames").addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    DataSource.instance.checkName(diff.document.documentID, diff.document.data(), true)
//                    print("New male name \(diff.document.documentID): \(diff.document.data())")
                }
                if (diff.type == .modified) {
                    DataSource.instance.editName(diff.document.documentID, diff.document.data(), true)
//                    print("Modified male name \(diff.document.documentID): \(diff.document.data())")
                }
                if (diff.type == .removed) {
                    DataSource.instance.removeName(diff.document.documentID, true)
//                    print("Removed male name \(diff.document.documentID): \(diff.document.data())")
                }
            }
        }
        db.collection("femaleNames").addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    DataSource.instance.checkName(diff.document.documentID, diff.document.data(), false)
//                    print("New female name \(diff.document.documentID): \(diff.document.data())")
                }
                if (diff.type == .modified) {
                    DataSource.instance.editName(diff.document.documentID, diff.document.data(), false)
//                    print("Modified female name \(diff.document.documentID): \(diff.document.data())")
                }
                if (diff.type == .removed) {
                    DataSource.instance.removeName(diff.document.documentID, false)
//                    print("Removed female name \(diff.document.documentID): \(diff.document.data())")
                }
            }
        }
    }
    
    func handleNameList(_ snapshot:QuerySnapshot?, _ error: Error?, callblock block: @escaping (_ nameData:[[String:Any]], _ error: String?) -> ()) {
        if let error = error {
            block([], error.localizedDescription)
        } else {
            var data:[[String:Any]] = []
            for document in snapshot!.documents {
                let arr:[String:Any] = [Constants.nameKeyNameID: document.documentID]
                var arr2:[String:Any] = [:]
                for (key, value) in document.data() {
                    arr2[key] = value
                }
                let nameData = arr.merging(arr2) { (_, new) in new }
                data.append(nameData)
                continue
            }
            block(data, nil)
        }
    }
    
    func getSearchMaleNames(_ search:String, callblock block: @escaping (_ data:[[String:Any]]?, _ error:String?) -> ()) {
        print(search)
        db.collection("maleNames").getDocuments() { (querySnapshot, error) in
            self.handleNameList(search, querySnapshot, error) { (data, error) in
                block(data, error)
            }
        }
    }
    
    func getSearchFemaleNames(_ search:String, callblock block: @escaping (_ data:[[String:Any]]?, _ error:String?) -> ()) {
        db.collection("femaleNames").getDocuments() { (querySnapshot, error) in
            self.handleNameList(search, querySnapshot, error) { (data, error) in
                block(data, error)
            }
        }
    }
    
    func handleNameList(_ searchWord:String, _ snapshot:QuerySnapshot?, _ error: Error?, callblock block: @escaping (_ nameData:[[String:Any]], _ error: String?) -> ()) {
        if let error = error {
            block([], error.localizedDescription)
        } else {
            var data:[[String:Any]] = []
            for document in snapshot!.documents {
                if let name = document["name"] as? String, name.contains(searchWord) {
                    let arr:[String:Any] = [Constants.nameKeyNameID: document.documentID]
                    var arr2:[String:Any] = [:]
                    for (key, value) in document.data() {
                        arr2[key] = value
                    }
                    let nameData = arr.merging(arr2) { (_, new) in new }
                    data.append(nameData)
                }
                continue
            }
            block(data, nil)
        }
    }
    
    func saveCustomName(_ name:String, _ isMale:Bool) {
        let data = [
            "name": name,
            "isMale": isMale
        ] as [String : Any]
        db.collection("customNames").addDocument(data:data) { err in
            if let err = err {
                print("Error writing document: \(err)")
            }
        }
    }
    
    func saveFavoriteName(_ name:String, _ isMale:Bool) {
        let data = [
            "name": name,
            "isMale": isMale
        ] as [String : Any]
        db.collection("favoriteNames").addDocument(data:data) { err in
            if let err = err {
                print("Error writing document: \(err)")
            }
        }
    }
    
}
