//
//  Photo.swift
//  Snacktacular
//
//  Created by Morgan Prime on 11/16/20.
//

import UIKit
import Firebase


class Photo {
    var image: UIImage
    var description: String
    var photoUserID: String
    var photoUserEmail: String
    var date: Date
    var photoURL: String
    var documentID: String
    
    var dictionary: [String: Any]{
        let timeIntervalDate = date.timeIntervalSince1970
        return["description":description, "photoUserID":photoUserID, "photoUserEmail": photoUserEmail, "date": timeIntervalDate, "photoURL":photoURL]
    }
    
    init(image: UIImage, description: String, photoUserID: String, photoUserEmail: String, date: Date, photoURL: String, documentID: String){
        self.image = image
        self.description = description
        self.photoUserID = photoUserID
        self.photoUserEmail = photoUserEmail
        self.date = date
        self.photoURL = photoURL
        self.documentID = documentID
        
    }
  
    convenience init(){
        let photoUserID = Auth.auth().currentUser?.uid ?? ""
        let photoUserEmail = Auth.auth().currentUser?.email ?? "unknown email"
        self.init(image: UIImage(), description: "", photoUserID: photoUserID, photoUserEmail: photoUserEmail, date: Date()  , photoURL: "", documentID: "")
    }
    
    convenience init(dictionary: [String: Any]){
        let description = dictionary["description"] as! String? ?? ""
        let photoUserID = dictionary["photoUserID"] as! String? ?? ""
        let photoUserEmail = dictionary["photoUserEmail"] as! String? ?? ""
        let timeIntervalDate = dictionary["date"] as! TimeInterval? ?? TimeInterval()
        let date = Date(timeIntervalSince1970: timeIntervalDate)
        let photoURL = dictionary["photoURL"] as! String? ?? ""

        self.init(image: UIImage(), description: description, photoUserID: photoUserID, photoUserEmail: photoUserEmail, date: date, photoURL: photoURL, documentID: "")
    }
    
    func saveData(spot: Spot, completion: @escaping (Bool) -> ()){
        let db = Firestore.firestore()
        let storage = Storage.storage()
        
        //convert photo.image to data
        guard let photoData = self.image.jpegData(compressionQuality: 0.5) else{
            print("Error couldnt convert photo to data")
            return
        }
        
        //create metadata so we can ssee images in console
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        //create filename if necessary
        if documentID == ""{
            documentID = UUID().uuidString
        }
        //create storage ref to upload this image to this spots folder
        let storageRef = storage.reference().child(spot.documentID).child(documentID)
        
        let uploadTask = storageRef.putData(photoData, metadata: uploadMetaData) { (metadata, error) in
            if let error = error {
                print("Error: upload for ref \(uploadMetaData), \(error.localizedDescription)")
            }
        }
        uploadTask.observe(.success) { (snapshot) in
            print("upload to firebase storage was successful")
            //grab user id
            let dataToSave: [String: Any] = self.dictionary
            
            let ref = db.collection("spots").document(spot.documentID).collection("reviews").document((self.documentID))
            ref.setData(dataToSave) {(error) in
                guard error == nil else{
                    print("Error: \(error!.localizedDescription)")
                    return completion(false)
                }
                print("Added document: \(self.documentID) in spot \(spot.documentID)")
                completion(true)
            }
        }
        
        uploadTask.observe(.failure) { (snapshot) in
            if let error = snapshot.error{
                print("error: \(self.documentID) failed in spot \(spot.documentID), error: \(error.localizedDescription)")
            }
            completion(false)
        }
    }
}
