//
//  AddPlaceViewController.swift
//  FreeParkingSpots
//
//  Created by Ilgar Ilyasov on 12/11/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import CoreLocation

class AddPlaceViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var imageCountLabel: UILabel!
    
    private var images = [UIImage]() {
        didSet {
            if images.count > 1 {
                imageCountLabel.isHidden = false
                imageCountLabel.layer.cornerRadius = 5
                imageCountLabel.text = " \(images.count)/ \(images.count) "
                addPhotoButton.setTitle("Add More Photo", for: .normal)
            } else {
                imageCountLabel.isHidden = true
            }
        }
    }
    
    private var currentImage = UIImage()
//    var parkingSpotController = ParkingSpotController()
    let locationManager = CLLocationManager()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageCountLabel.layer.cornerRadius = 5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageCountLabel.isHidden = true
        imageCountLabel.layer.cornerRadius = 5
        
        nameTextField.delegate = self
        detailsTextView.delegate = self
        
        
        detailsTextViewTapGesture()
        imageSwipeGesture()
        imageTapGesture()
    }
    
    
    private func detailsTextViewTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideUnhideKeyboard))
        detailsTextView.isUserInteractionEnabled = true
        detailsTextView.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideUnhideKeyboard() {
        if detailsTextView.isFirstResponder {
            detailsTextView.resignFirstResponder()
        } else {
            detailsTextView.becomeFirstResponder()
        }
    }
    
    private func imageSwipeGesture() {
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(gesture:)))
        rightGesture.direction = .right
        
        let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(gesture:)))
        leftGesture.direction = .left
        
        placeImageView.isUserInteractionEnabled = true
        placeImageView.addGestureRecognizer(rightGesture)
        placeImageView.addGestureRecognizer(leftGesture)
    }
    
    @objc func handleSwipe(gesture: UISwipeGestureRecognizer) {
        if gesture.state == .ended {
            
            guard let currentImage = placeImageView.image,
                var index = images.index(of: currentImage) else { return }
            
            switch gesture.direction {
            case .right:
                if index < (images.count - 1) {
                    index += 1
                    placeImageView.image = images[index]
                    imageCountLabel.layer.cornerRadius = 5
                    imageCountLabel.text = " \(index + 1)/ \(images.count) "
                }
            case .left:
                if index > 0 {
                    index -= 1
                    placeImageView.image = images[index]
                    imageCountLabel.layer.cornerRadius = 5
                    imageCountLabel.text = " \(index + 1)/ \(images.count) "
                }
            default:
                break
            }
        }
    }
    
    private func imageTapGesture() {
        guard let image = placeImageView.image else { return }
        currentImage = image
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnImage(sender:)))
        placeImageView.isUserInteractionEnabled = true
        placeImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTapOnImage(sender: UITapGestureRecognizer) {
        let fullScreen = FullScreenImageViewController()
        fullScreen.image = currentImage
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let fullScreenVC = storyBoard.instantiateViewController(withIdentifier: "FullScreenImageViewController")
        present(fullScreenVC, animated: true, completion: nil)
    }
    
    @IBAction func addPhotoButtonTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePC = UIImagePickerController()
            imagePC.delegate = self
            imagePC.sourceType = .camera
            imagePC.allowsEditing = false
            present(imagePC, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickedImage = info[.originalImage] as! UIImage
        images.append(pickedImage)
        placeImageView.image = pickedImage
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func locationOnOffSwitch(_ sender: UISwitch) {
        if sender.isOn {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            if CLLocationManager.locationServicesEnabled() {
                locationManager.startUpdatingLocation()
            }
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let name = nameTextField.text,
            let detail = detailsTextView.text,
            let lat = locationManager.location?.coordinate.latitude,
            let lon = locationManager.location?.coordinate.longitude else { return }
        
        ParkingSpotController.shared.createParkingSpot(name: name, images: self.images, detail: detail, latitude: lat, longitude: lon)
        
        presentInformationalAlertController(title: "Completed", message: "New parking spot added to the map!", dismissActionCompletion: nil) {
            self.nameTextField.text = ""
            self.detailsTextView.text = ""
            self.placeImageView.image = UIImage(named: "placeholder")
            let newImages = [UIImage]()
            self.images = newImages
            self.addPhotoButton.setTitle("Add Photo", for: .normal)
        }
        
    }
}

extension AddPlaceViewController: UITextViewDelegate, UITextFieldDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        view.frame.origin.y = -200
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        view.frame.origin.y = 0
        textView.enablesReturnKeyAutomatically = true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        detailsTextView.resignFirstResponder()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        view.frame.origin.y = 0
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        view.frame.origin.y = -200
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.frame.origin.y = 0
    }
    
}

extension AddPlaceViewController {
    func presentInformationalAlertController(title: String?, message: String?, dismissActionCompletion: ((UIAlertAction) -> Void)? = nil, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: dismissActionCompletion)
        
        alertController.addAction(dismissAction)
        
        present(alertController, animated: true, completion: completion)
    }
}
