//
//  ReviewTableViewController.swift
//  Snacktacular
//
//  Created by Morgan Prime on 11/8/20.
//

import UIKit
import Firebase

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    return dateFormatter
}()

class ReviewTableViewController: UITableViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var postedByLabel: UILabel!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var buttonsBackgroundView: UIView!
    @IBOutlet weak var reviewTitleLabel: UILabel!
    @IBOutlet weak var reviewDateLabel: UILabel!
    
    @IBOutlet weak var reviewTextView: UITextView!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet var starButtonCollection: [UIButton]!
    
    var review: Review!
    var spot: Spot!
    var rating = 0 {
        didSet{
            for starButton in starButtonCollection {
                let imageName = (starButton.tag < rating ? "star.fill":"star")
                starButton.setImage(UIImage(systemName: imageName), for: .normal)
                starButton.tintColor = (starButton.tag < rating ? .systemRed : .darkText)
            }
            review.rating = rating
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        guard spot != nil else{
            print("No spot passed")
            return
        }
        if review == nil {
            review = Review()
        }
        updateUserInterface()

    }
    
    func updateUserInterface(){
        nameLabel.text = spot.name
        addressLabel.text = spot.address
        reviewTitleLabel.text = review.title
        reviewTextView.text = review.text
        rating = review.rating //update stars
        reviewDateLabel.text = "Posted: \(dateFormatter.string(from: review.date))"
        if review.documentID == "" {// new review
            addBordersToEditableObjects()
        }
        else{
            if review.reviewUserID == Auth.auth().currentUser?.uid { // review poseted by current user
                self.navigationItem.leftItemsSupplementBackButton = false
                saveBarButton.title = "Update"
                addBordersToEditableObjects()
                deleteButton.isHidden = false
            }
            else{ // diff user
                saveBarButton.hide()
                cancelBarButton.hide()
                //eventually change uid to email
                postedByLabel.text = "Posted by: \(review.reviewUserEmail)"
                for starButton in starButtonCollection{
                    starButton.backgroundColor = .white
                    starButton.isEnabled = false
                }
                reviewTitleLabel.isEnabled = false
                reviewTitleLabel.noBorder() // iffy
                reviewTextView.isEditable = false
                reviewTitleLabel.backgroundColor = .white
                reviewTextView.backgroundColor = .white
                
            }
        }
    }
    func updateFromUserInterface(){
        review.title = reviewTitleLabel.text!
        review.text = reviewTextView.text!
        
    }
    
    func addBordersToEditableObjects(){
        reviewTitleLabel.addBorder(width: 0.5, radius: 5.0, color: .black)
        reviewTextView.addBorder(width: 0.5, radius: 5.0, color: .black)
        buttonsBackgroundView.addBorder(width: 0.5, radius: 5.0, color: .black)


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

    @IBAction func reviewTitleChanged(_ sender: UITextField) {
        let noSpaces = reviewTitleLabel.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if noSpaces != ""{
            saveBarButton.isEnabled = true
        }
        else{
            saveBarButton.isEnabled = false
        }
    }
    
    
    @IBAction func reviewTitleDonePressed(_ sender: UITextField) {
    }
    
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        review.deleteData(spot: spot) { (success) in
            if success{
                self.leaveViewController()
            }
            else{
                print("Delete Unsuccessful")
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        updateFromUserInterface()
        review.saveData(spot: spot) { (success) in
            if success{
                self.leaveViewController()
            }
            else{
                print("Cant unwind from review")
            }
        }
    }
    
    @IBAction func starButtonPressed(_ sender: UIButton) {
        rating = sender.tag + 1
    }
    
    
}
