//
//  ViewController.swift
//  MemeMev2p0
//
//  Copyright © 2020 Dushyant Juneja. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UINavigationControllerDelegate,
    UIImagePickerControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var pickerToolbar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topLabel: UITextField!
    @IBOutlet weak var bottomLabel: UITextField!
    @IBOutlet weak var navToolbar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var isFirstEditTop: Bool = true
    var isFirstEditBottom: Bool = true
    var memeObject: Meme!
    
    // Generic text attribs for Meme
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3.2
    ]

    func save() {
        let memedImage: UIImage = generateMemedImage()
        self.memeObject =
            Meme(topText: topLabel.text!,
                 bottomText: bottomLabel.text!,
                 originalImage: imagePickerView.image!,
                 memedImage: memedImage)
    }
    
    func hideToolbar (hide: Bool) {
        pickerToolbar.isHidden = hide
        navToolbar.isHidden = hide
    }
    
    func generateMemedImage() -> UIImage {
        hideToolbar(hide: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hideToolbar(hide: false)
        return memedImage
    }
    
    @IBAction func shareAction(_ sender: Any) {
        let memedImage: UIImage = generateMemedImage()
        let shareSheet = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        shareSheet.completionWithItemsHandler = { (_, completed, _, _) in
            if (completed) {
                self.save()
            }
        }
        present(shareSheet, animated: true, completion: nil)
    }
    
    func setTextField(field: UITextField, toText: String) {
        field.defaultTextAttributes = memeTextAttributes
        field.adjustsFontSizeToFitWidth = true
        field.textAlignment = .center
        field.delegate = self
        field.text = toText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setTextField(field: self.topLabel, toText: "TOP")
        setTextField(field: self.bottomLabel, toText: "BOTTOM")
        shareButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        cameraButton.isEnabled =
            UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomLabel.isEditing, view.frame.origin.y == 0 {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if bottomLabel.isEditing, view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }

    // dismiss the keyboard when touched elsewhere on screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey]
            as! NSValue // of CGRect
        // print(userInfo![UIResponder])
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(
            self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(
            self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func imagePickerController(_
        picker: UIImagePickerController, didFinishPickingMediaWithInfo
        info: [UIImagePickerController.InfoKey : Any]) {
        if let imageObj = info[.originalImage] as? UIImage {
            imagePickerView.image = imageObj
            imagePickerView.contentMode = .scaleAspectFit
            shareButton.isEnabled = true
            dismiss(animated: true, completion: nil)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == topLabel, isFirstEditTop == true {
            textField.text = ""
            isFirstEditTop = false
        }
        if textField == bottomLabel, isFirstEditBottom == true {
            textField.text = ""
            isFirstEditBottom = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
     
    @IBAction func pickImage(_ sender: Any) {
        let input = sender as! UIBarButtonItem
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = input.tag == 0 ? .camera : .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func discardMeme(_ sender: Any) {
        shareButton.isEnabled = false
        imagePickerView.image = nil
        topLabel.text = "TOP"
        bottomLabel.text = "BOTTOM"
    }
}

