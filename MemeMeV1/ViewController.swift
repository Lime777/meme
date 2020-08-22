//
//  ViewController.swift
//  MemeMeV1
//
//  Created by Emil Haroutunian on 7/29/20.
//  Copyright © 2020 Emil Haroutunian. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    
    struct Meme {
        var topText: String
        var bottomText: String
        var originalImage: UIImage
        var memedImage: UIImage
        
    }
    
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  5
    ]
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var share: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
        
        topTextField.text = "Enter Text Here"
        bottomTextField.text = "Enter Text Here"
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.clearsOnBeginEditing = true
        bottomTextField.clearsOnBeginEditing = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        subScribeToKeyboardWillHide()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    //This action/button finds its way to the UIImagePickerController and into the photoLibrary source
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    @IBAction func camera(_ sender: UIButton) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            
            present(imagePicker, animated: true, completion: nil)
        } else {
            sender.isEnabled = false
        }
        
    }
    
    
    @IBAction func share(_ sender: UIButton) {
        
        
        
        let memedImage: UIImage = generateMemedImage()
        
        
        let shareSheet = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        shareSheet.excludedActivityTypes = [.postToFacebook, .postToTwitter, .message, .mail]

        shareSheet.completionWithItemsHandler = { (_, completed, _, _) in

            if (completed) {

                self.save()
                print("it worked")
            } else {
                print("Check your code")
            }

            self.dismiss(animated: true, completion: nil)

        }
        
        present(shareSheet, animated: true, completion: nil)
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        
        topTextField.text = "Enter Text Here"
        bottomTextField.text = "Enter Text Here"
        imagePickerView.image = .none
        
    }
    
    //This is a protocol method that grabs the users picked image and puts it on the UIImageView.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            
        {
            
            imagePickerView.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    
    func subScribeToKeyboardWillHide() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if bottomTextField.isEditing, view.frame.origin.y == 0 {
            
            view.frame.origin.y -= getKeyboardHeight(notification)
            
        }
        
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        if bottomTextField.isEditing, view.frame.origin.y != 0 {
            
            view.frame.origin.y = 0
            
        }
        
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        toolBar.isHidden = true
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        
        toolBar.isHidden = false
        
        
        navigationController?.setToolbarHidden(true, animated: true)
        
        return memedImage
    }
    func save(){
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        
    }
    
    
}

