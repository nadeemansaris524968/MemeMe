//
//  ViewController.swift
//  Testing Image Picker
//
//  Created by Nadeem Ansari on 6/7/17.
//  Copyright © 2017 Nadeem Ansari. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    var pickerController = UIImagePickerController()
    
    @IBOutlet weak var topTF: UITextField!
    
    @IBOutlet weak var bottomTF: UITextField!

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        topTF.delegate = self
        bottomTF.delegate = self
        
        
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = false
        
        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: 4]
        
        topTF.defaultTextAttributes = memeTextAttributes
        bottomTF.defaultTextAttributes = memeTextAttributes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pickImage(_ sender: Any) {
        
        self.present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func clickImage(_ sender: Any) {
        
        pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .camera
        pickerController.allowsEditing = false
        
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        pickerController.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        pickerController.dismiss(animated: true, completion: nil)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
   
}

