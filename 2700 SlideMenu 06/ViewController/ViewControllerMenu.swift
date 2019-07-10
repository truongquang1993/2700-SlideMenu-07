//
//  ViewControllerMenu.swift
//  2700 SlideMenu 06
//
//  Created by Trương Quang on 7/10/19.
//  Copyright © 2019 truongquang. All rights reserved.
//

import UIKit

class ViewControllerMenu: UIViewController {
    
    @IBOutlet weak var outletImage: UIImageView!
    @IBOutlet weak var outletName: UITextField!
    @IBOutlet weak var outletPhoneNumber: UITextField!
    
    var infor: Infor?
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        fillInfor()
        
        outletImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addPhoto))
        outletImage.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addphoto), name: .passDataMain, object: nil)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    @objc func addphoto(notification: Notification) {
        let recInfor = notification.object as! Infor
        infor = recInfor
        fillInfor()
    }
    
    func fillInfor(){
        outletImage.image = infor?.image ?? UIImage(named: "nophoto")
        if let infor = self.infor {
            outletImage.image = infor.image
            outletName.text = infor.name
            outletPhoneNumber.text = infor.phonenumber
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        outletImage.layer.cornerRadius = outletImage.bounds.width / 2
        outletImage.layer.borderColor = UIColor.gray.cgColor
        outletImage.layer.borderWidth = 1
        outletImage.layer.masksToBounds = true
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func addPhoto() {
        let alertController = UIAlertController(title: "Choose from", message: nil, preferredStyle: .actionSheet)
        
        //From camera
        let fromcamera = UIAlertAction(title: "From camera", style: .default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .camera
                self.imagePicker.cameraCaptureMode = .photo
                self.imagePicker.modalPresentationStyle = .fullScreen
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                self.showAlert(message: "Device is not support camera")
            }
        }
        
        // From library
        let fromLibrary = UIAlertAction(title: "From library", style: .default) { (_) in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(fromcamera)
        alertController.addAction(fromLibrary)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func actionSave(_ sender: Any) {
        guard let image = outletImage.image else { return }
        guard let name = outletName.text else { return }
        guard let phoneNumber = outletPhoneNumber.text else { return }
        
        infor = Infor(image: image, name: name, phonenumber: phoneNumber)
        NotificationCenter.default.post(name: .passDataMenu, object: self.infor)
    }
    
}

extension ViewControllerMenu: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let choose = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        outletImage.image = choose
        dismiss(animated: true, completion: nil)
    }
}
