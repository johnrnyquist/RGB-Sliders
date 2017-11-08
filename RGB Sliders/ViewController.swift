//
//  ViewController.swift
//  RGB Sliders
//
//  Created by John Nyquist on 11/4/17.
//  Copyright © 2017 Nyquist Art + Logic LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var colorSquare: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var posterizeSlider: UISlider!
    @IBOutlet weak var posterizeSwitch: UISwitch!

    var originalImage:UIImage?
    let context = CIContext(options: nil)

     override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load preferences
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "hasRun") {
            redSlider.value = defaults.float(forKey: "red")
            greenSlider.value = defaults.float(forKey: "green")
            blueSlider.value = defaults.float(forKey: "blue")
        }else{
            defaults.set(true, forKey: "hasRun")
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        updateBackgroundColor()
        colorSquare.layer.borderColor = UIColor.black.cgColor
        colorSquare.layer.borderWidth = 1
        originalImage = photoImageView.image!
    }
    
    func applyFilter() {
        
        // Create an image to filter
        let inputImage = CIImage(image: photoImageView.image!)
        
        let filterData = ["inputImage": inputImage!, "inputLevels": posterizeSlider.value] as [String : Any]
        
        // Apply a filter to the image
        let filteredImage = inputImage?.applyingFilter("CIColorPosterize", parameters: filterData)
        
        // Render the filtered image
        let renderedImage = context.createCGImage(filteredImage!, from: filteredImage!.extent)
        
        // Reflect the change back in the interface
        photoImageView.image = UIImage(cgImage: renderedImage!)
    }

    @IBAction func posterizeSliderChanged(_ sender: Any) {
        posterizeSwitch.isOn = true //this does result in calling action
        applyFilter()
    }

    @IBAction func posterizeAction(_ sender: UISwitch) {
        if posterizeSwitch.isOn {
            applyFilter()
        }else{
            photoImageView.image = originalImage
        }
    }
    
    @IBAction func updateBackgroundColor() {
        let red = CGFloat(redSlider.value)
        let green = CGFloat(greenSlider.value)
        let blue = CGFloat(blueSlider.value)
        
        colorSquare.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
        
        // Save preferences
        let defaults = UserDefaults.standard
        defaults.set(redSlider.value, forKey: "red")
        defaults.set(greenSlider.value, forKey: "green")
        defaults.set(blueSlider.value, forKey: "blue")
        defaults.synchronize()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "openColor"){
            let newViewController = segue.destination
            newViewController.view.backgroundColor = colorSquare.backgroundColor
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

