//
//  SpotTableViewCell.swift
//  Snacktacular
//
//  Created by Morgan Prime on 11/8/20.
//

import UIKit
import CoreLocation

class SpotTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!

    var currentLocation: CLLocation!
    var spot: Spot! {
        didSet {
            nameLabel.text = spot.name
            let roundedAvg = ((spot.averageRating * 10).rounded())/10
            ratingLabel.text = "Avg. Rating: \(roundedAvg)"
            
            guard let currentLocation = currentLocation else {
                distanceLabel.text = "Distance: _._"
                return
            }
            let distanceInMeters = spot.location.distance(from: currentLocation)
            let distanceInMiles = ((distanceInMeters * 0.00062137) * 10).rounded() / 10
            distanceLabel.text = "Distance: \(distanceInMiles) miles"
        }
    }
    
}
