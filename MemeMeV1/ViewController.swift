//
//  ViewController.swift
//  MemeMeV1
//
//  Created by Emil Haroutunian on 7/29/20.
//  Copyright © 2020 Emil Haroutunian. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
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
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var canelButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField(topTextField, "Enter Meme Text")
        setupTextField(bottomTextField, "Enter Meme Text")
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
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
        pickFromSource(.photoLibrary)
    }
    
    
    @IBAction func camera(_ sender: UIButton) {
        pickFromSource(.camera)
    }
    
    
    @IBAction func share(_ sender: Any) {
       
    
        let memeImage: UIImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)

        controller.completionWithItemsHandler = {( type, ok, items, error ) in
            if ok {
                self.save()
            }
        }
        self.present(controller, animated: true, completion: nil)
    
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        
       dismiss(animated: true)
        
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


        // Create the meme
         let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
         // Add it to the memes array in the Application Delegate

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
        dismiss(animated: true, completion: nil)
        
    }
    
    func setupTextField(_ textField: UITextField, _ defaultText: String) {
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.text = defaultText
        textField.clearsOnBeginEditing = true
        
    }
    
    func pickFromSource(_ source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self;
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
}

