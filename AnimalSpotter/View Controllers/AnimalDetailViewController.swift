//
//  AnimalDetailViewController.swift
//  AnimalSpotter
//
//  Created by Sean Acres on 6/20/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class AnimalDetailViewController: UIViewController {

    @IBOutlet weak var timeSeenLabel: UILabel!
    @IBOutlet weak var coordinatesLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var animalImageView: UIImageView!
    
    var animalName: String?
    var apiController: APIController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDetails()
    }
    
    func getDetails() {
        guard let apiController = apiController, let animalName = animalName else { return }
        apiController.fetchDetails(for: animalName) { (result) in
            if let animal = try? result.get() {
                DispatchQueue.main.async {
                    self.updateViews(with: animal)
                }
                // fetch image for animal
                apiController.fetchImage(at: animal.imageURL, completion: { (result) in
                    if let image = try? result.get() {
                        DispatchQueue.main.async {
                            self.animalImageView.image = image
                        }
                    }
                })
            }
        }
    }
    
    func updateViews(with animal: Animal) {
        title = animal.name
        descriptionLabel.text = animal.description
        coordinatesLabel.text = "lat: \(animal.latitude), long: \(animal.longitude)"
        
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        
        timeSeenLabel.text = df.string(from: animal.timeSeen)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
