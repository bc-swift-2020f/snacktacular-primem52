//
//  Spots.swift
//  Snacktacular
//
//  Created by Morgan Prime on 11/8/20.
//

import Foundation
import Firebase
import FirebaseFirestore

class Spots{
    var spotArray: [Spot] = []
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
            self.spotArray = []
            for document in querySnapshot!.documents {
                let spot = Spot(dictionary: document.data())
                spot.documentID = document.documentID
                self.spotArray.append(spot)
            }
        }
    }
    
}
