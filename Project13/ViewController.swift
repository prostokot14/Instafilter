//
//  ViewController.swift
//  Project13
//
//  Created by Антон Кашников on 04/11/2023.
//

import UIKit

final class ViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intensity: UILabel!
    
    // MARK: - Private properties
    
    private var currentImage: UIImage!
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Instafilter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(importPicture)
        )
    }
    
    // MARK: - Private methods
    
    @objc
    private func importPicture() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    // MARK: - IBActions

    @IBAction func changeFilter(_ sender: Any) {
    }
    
    @IBAction func save(_ sender: Any) {
    }
    
    @IBAction func intensityChanged(_ sender: Any) {
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        currentImage = image
    }
}
