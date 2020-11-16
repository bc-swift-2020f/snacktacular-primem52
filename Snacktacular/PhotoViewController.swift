//
//  PhotoViewController.swift
//  Snacktacular
//
//  Created by Morgan Prime on 11/16/20.
//

import UIKit

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    @IBOutlet weak var deleteBarButton: UIBarButtonItem!
    
    
    var spot: Spot!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        guard spot != nil else{
            print("error No spot passed to PhotoViewController")
            return
        }

        // Do any additional setup after loading the view.
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
    }
    @IBAction func cancelButtonPessed(_ sender: UIBarButtonItem) {
    }
    @IBAction func saveButtonPessed(_ sender: UIBarButtonItem) {
        //TODO:- More stuff
        leaveViewController()
    }
    
}
