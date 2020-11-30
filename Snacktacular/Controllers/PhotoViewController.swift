//
//  PhotoViewController.swift
//  Snacktacular
//
//  Created by Morgan Prime on 11/16/20.
//

import UIKit
import Firebase
import SDWebImage

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    return dateFormatter
}()

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    @IBOutlet weak var deleteBarButton: UIBarButtonItem!
    
    
    @IBOutlet weak var postedByLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    var spot: Spot!
    var photo: Photo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        guard spot != nil else{
            print("error No spot passed to PhotoViewController")
            return
        }
        
        if photo == nil {
            photo = Photo()
        }
        updateUserInterface()
        // Do any additional setup after loading the view.
    }
    
    func updateUserInterface(){
        postedByLabel.text = "By: \(photo.photoUserEmail)"
        dateLabel.text = "On: \(dateFormatter.string(from: photo.date))"
        descriptionTextView.text = photo.description
        photoImageView.image = photo.image
        
        if photo.documentID == "" {// new photo
            addBordersToEditableObjects()
        }
        else{
            if photo.photoUserID == Auth.auth().currentUser?.uid { // photo poseted by current user
                self.navigationItem.leftItemsSupplementBackButton = false
                saveBarButton.title = "Update"
                addBordersToEditableObjects()
                self.navigationController?.setToolbarHidden(false, animated: true)
            }
            else{ // diff user
                saveBarButton.hide()
                cancelBarButton.hide()
                //eventually change uid to email
                postedByLabel.text = "Posted by: \(photo.photoUserEmail)"
               
                descriptionTextView.isEditable = false
                descriptionTextView.backgroundColor = .white
                
            }
        }
        guard let url = URL(string: "\(photo.photoURL)") else{
            print("URl didnt work")
            photoImageView.image = photo.image
            return
        }
        photoImageView.sd_imageTransition = .fade
        photoImageView.sd_imageTransition?.duration = 0.5
        photoImageView.sd_setImage(with: url)
        
    }
    
    func updateFromUserInterface(){
        photo.description = descriptionTextView.text
        photo.image = photoImageView.image!
    }
    
    func addBordersToEditableObjects(){
        descriptionTextView.addBorder(width: 0.5, radius: 5.0, color: .black)
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        }
        else {
            navigationController?.popViewController(animated: true)
        }
    }
    

    
    @IBAction func deleteButtonPessed(_ sender: UIBarButtonItem) {
        photo.deleteData(spot: spot){ (success) in
            if success{
                self.leaveViewController()
            }
            else{
                print("cant unwind")
            }
        }
    }
    @IBAction func cancelButtonPessed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    @IBAction func saveButtonPessed(_ sender: UIBarButtonItem) {
        updateFromUserInterface()
        photo.saveData(spot: spot) { (success) in
            if success{
                self.leaveViewController()
            }
            else{
                print("Cant unwind from PhotoViewController bc phtoo saving error")
            }
        }
    }
    
}
