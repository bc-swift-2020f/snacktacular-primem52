//
//  SpotReviewTableViewCell.swift
//  Snacktacular
//
//  Created by Morgan Prime on 11/9/20.
//

import UIKit

class SpotReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var reviewTitleLabel: UILabel!
    @IBOutlet weak var reviewTextLabel: UILabel!
    
    @IBOutlet var starImageConnection: [UIImageView]!
    
    var review: Review!{
        didSet{
            reviewTitleLabel.text = review.title
            reviewTextLabel.text = review.text
            
            for starImage in starImageConnection {
                let imageName = (starImage.tag < review.rating ? "star.fill":"star")
                starImage.image = UIImage(systemName: imageName)
                starImage.tintColor = (starImage.tag < review.rating ? .systemRed : .darkText)
            }
        }
    }
}
