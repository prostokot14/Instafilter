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
        
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(intensity.value * 200, forKey: kCIInputRadiusKey)
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey)
        }
        
        if inputKeys.contains(kCIInputCenterKey) {
            currentFilter.setValue(
                CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2),
                forKey: kCIInputCenterKey
            )
        }
        
        if let cgImage = context.createCGImage(image, from: image.extent) {
            let processedImage = UIImage(cgImage: cgImage)
            imageView.image = processedImage
        }
    }
    
    private func showFiltersAlert() {
        let filters = ["CIBumpDistortion", "CIGaussianBlur", "CIPixellate", "CISepiaTone", "CITwirlDistortion", "CIUnsharpMask", "CIVignette"]
        let alertController = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        
        filters.forEach {
            alertController.addAction(UIAlertAction(title: $0, style: .default, handler: setFilter))
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    private func setCurrentImageAsInput() {
        currentFilter.setValue(CIImage(image: currentImage), forKey: kCIInputImageKey)
    }
    
    @objc
    private func setFilter(action: UIAlertAction) {
        guard
            currentImage != nil,
            let actionTitle = action.title
        else { return }
        
        currentFilter = CIFilter(name: actionTitle)
        
        setCurrentImageAsInput()
        applyProcessing()
    }
    
    // MARK: - IBActions

    @IBAction func changeFilter(_ sender: Any) {
        showFiltersAlert()
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
        
        setCurrentImageAsInput()
        applyProcessing()
    }
}
