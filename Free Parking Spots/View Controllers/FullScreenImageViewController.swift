//
//  FullScreenImageViewController.swift
//  FreeParkingSpots
//
//  Created by Ilgar Ilyasov on 12/13/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit

class FullScreenImageViewController: UIViewController {

    var image: UIImage? {
        didSet { updateViews() }
    }
    @IBOutlet weak var fullScreenImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    @IBAction func xButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func updateViews() {
        guard let image = image else { return }
        fullScreenImageView.image = image
    }
}
