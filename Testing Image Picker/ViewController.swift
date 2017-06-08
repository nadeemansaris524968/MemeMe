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
    
    @IBOutlet weak var shareBTN: UIBarButtonItem!
    
    @IBOutlet weak var navbar: UINavigationBar!
    
    @IBOutlet weak var topTF: UITextField!
    
    @IBOutlet weak var bottomTF: UITextField!

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Disabling Share button when imageView is nil
        if (imageView.image == nil){
            shareBTN.isEnabled = false
        }
        
        topTF.text = "TOP"
        bottomTF.text = "BOTTOM"
            
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = false
        
        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -2 ]
        
        topTF.defaultTextAttributes = memeTextAttributes
        bottomTF.defaultTextAttributes = memeTextAttributes
        
        topTF.delegate = self
        bottomTF.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func shareBTN(_ sender: Any) {
        
        let memedImage:UIImage = generateMemedImage()
        
        let memeToShare:[UIImage] = [memedImage]
        
        let activityViewController = UIActivityViewController(activityItems: memeToShare, applicationActivities: nil)
        
        // So that the app on iPads doesn't crash
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true) { 
            self.save(memedImage)
        }
    }
    
    func save(_ memedImage:UIImage){
        
        // Create the meme
        let meme = Meme(topText: topTF.text!, bottomText: bottomTF.text!, originalImage: imageView.image!, memedImage: memedImage)
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        toolbar.isHidden = true
        navbar.isHidden = true
        
        // Render view to an image. Basically grabbing the screen
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Unhide toolbar
        toolbar.isHidden = false
        navbar.isHidden = false
        
        return memedImage
    }
    
    func keyboardWillHide(_ notification:Notification) {
        
        self.view.frame.origin.y = 0
    }
    
    // Method to move the view vertically
    func keyboardWillShow(_ notification:Notification ){
        
        if bottomTF.isEditing == true {
        self.view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }
    
    // Retrieves the height of the keyboard
    func getKeyboardHeight(_ notification:Notification) -> CGFloat{
        
        let userInfo = notification.userInfo
        
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardSize.cgRectValue.height
    }
    
    // Listening for application wide event: UIKeyboardWillShow
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    // Not listening to UIKeyboardWillShow event
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
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
        
        if (imageView.image != nil){
            shareBTN.isEnabled = true
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        pickerController.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        pickerController.dismiss(animated: true, completion: nil)
        
        if (imageView.image != nil){
            shareBTN.isEnabled = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
   
}

