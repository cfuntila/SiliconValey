//
//  ViewController.swift
//  SiliconValley
//
//  Created by Charity Funtila on 2/28/20.
//  Copyright © 2020 Charity Funtila. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var starterImage: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            starterImage.image = userPickedImage
            
            guard let ciimage = CIImage(image: userPickedImage) else{
                fatalError("Could not convert to ciImage")
            }
            detect(image: ciimage)
        }
        
        

        imagePicker.dismiss(animated: true, completion: nil)
        



    }
    
    func detect(image: CIImage){
        // Set up model as a model of Inceptionv3
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else{
            fatalError("could not get model")
        }

        // Set up the results to connect with the model
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else{
                fatalError("Could not get results")
            }

            // Check that it is a hotdog
            if let firstResult = results.first {
                if firstResult.identifier.contains("hotdog"){
                    self.navigationItem.title = "Hotdog!"
                }else{
                    self.navigationItem.title = "Not Hotdog, " + firstResult.identifier
                }
            }

        }

        // Put image in a box(handler) to ship to the model
        let handler = VNImageRequestHandler(ciImage: image)

        // Now send the image to the Model
        do{
            try handler.perform([request])
        }catch{
            print(error)
        }
    }
    
 
    
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
}

