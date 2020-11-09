//
//  ReviewTableViewController.swift
//  Snacktacular
//
//  Created by Morgan Prime on 11/8/20.
//

import UIKit

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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
    }
    
    
    @IBAction func reviewTitleDonePressed(_ sender: UITextField) {
    }
    
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
    }
    
}
