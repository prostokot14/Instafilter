//
//  ViewController.swift
//  Project13
//
//  Created by Антон Кашников on 04/11/2023.
//

import CoreImage
import UIKit

final class ViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intensity: UISlider!
    
    // MARK: - Private properties
    
    private var currentImage: UIImage!
    private var context: CIContext!
    private var currentFilter: CIFilter!
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Instafilter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(importPicture)
        )
        
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
    }
    
    // MARK: - Private methods
    
    @objc
    private func importPicture() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    private func applyProcessing() {
        guard let image = currentFilter.outputImage else { return }
        
        currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
        
        if let cgImage = context.createCGImage(image, from: image.extent) {
            let processedImage = UIImage(cgImage: cgImage)
            imageView.image = processedImage
        }
    }
    
    // MARK: - IBActions

    @IBAction func changeFilter(_ sender: Any) {
    }
    
    @IBAction func save(_ sender: Any) {
    }
    
    @IBAction func intensityChanged(_ sender: Any) {
        applyProcessing()
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
        
        let inputImage = CIImage(image: currentImage)
        currentFilter.setValue(inputImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
}
