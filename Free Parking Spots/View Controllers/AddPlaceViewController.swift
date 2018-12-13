//
//  AddPlaceViewController.swift
//  FreeParkingSpots
//
//  Created by Ilgar Ilyasov on 12/11/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit

class AddPlaceViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var imageCountLabel: UILabel!
    
    private var images = [UIImage]() {
        didSet {
            if images.count > 1 {
                imageCountLabel.isHidden = false
                imageCountLabel.text = " 1/ \(images.count) "
            } else {
                imageCountLabel.isHidden = true
            }
        }
    }
    
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
        detailsTextView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideUnhideKeyboard))
        detailsTextView.addGestureRecognizer(tapGesture)
        
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(gesture:)))
        rightGesture.direction = .right
        
        let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(gesture:)))
        leftGesture.direction = .left
        
        
        placeImageView.addGestureRecognizer(rightGesture)
        placeImageView.addGestureRecognizer(leftGesture)
    }
    
    @objc func hideUnhideKeyboard() {
        if detailsTextView.isFirstResponder {
            detailsTextView.resignFirstResponder()
        } else {
            detailsTextView.becomeFirstResponder()
        }
    }
    
    @objc func handleSwipe(gesture: UISwipeGestureRecognizer) {
        if gesture.state == .ended {
            switch gesture.direction {
            case .right:
                placeImageView.image = images[1]
                imageCountLabel.layer.cornerRadius = 5
                imageCountLabel.text = " 2/ \(images.count) "
            case .left:
                placeImageView.image = images[0]
                imageCountLabel.layer.cornerRadius = 5
                imageCountLabel.text = " 1/ \(images.count) "
            default:
                break
            }
        }
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
        addPhotoButton.setTitle("Add More Photo", for: .normal)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        
        
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
