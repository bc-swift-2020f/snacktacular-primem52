//
//  SnackUsers.swift
//  Snacktacular
//
//  Created by Morgan Prime on 11/30/20.
//

import Foundation
import Firebase
import FirebaseFirestore

class SnackUsers {
    var userArray: [SnackUser] = []
    var db: Firestore!
    
    init(){
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()){
        db.collection("spots").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else{
                print("Error \(error?.localizedDescription)")
                return completed()
            }
            self.userArray = []
            for document in querySnapshot!.documents {
                let snackUser = SnackUser(dictionary: document.data())
                snackUser.documentID = document.documentID
                self.userArray.append(snackUser)
            }
        }
    }
    
}
