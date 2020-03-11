//
//  SignUpViewController.swift
//  RPower
//
//  Created by Rutul Desai on 2/21/20.
//  Copyright © 2020 Rutul Desai. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    let rest = RestManager()
    var imageURL:String?
    var schoolName:String = ""
    var avatarUploaded:Bool = false
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    @IBOutlet weak var imageViewButton: UIButton!
    @IBOutlet weak var schoolHeader: UILabel!
    @IBOutlet weak var schoolEmail: UILabel!
    
    @IBOutlet weak var confirmPasswordText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let defaults = UserDefaults.standard
        self.schoolName = defaults.object(forKey: "School") as! String
        if self.schoolName == "Haverford"
        {
            schoolHeader.text = "Haverford"
            schoolEmail.text = "@haverford.org"
        }
        else
        {
            schoolHeader.text = "Agnes Irwin"
            schoolEmail.text = "@agnesirwin.org"
        }
        
    }
    @IBAction func imageButtonTapped(_ sender: UIButton) {
       showImagePickerController()
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        if (userNameText.text == "" || passwordText.text == "" || confirmPasswordText.text == "" || emailText.text == "")
        {
           let optionMenu = UIAlertController(title: "Sign Up Failed", message: "Please fill in all the details", preferredStyle: .alert)
           let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
               (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
           })
            optionMenu.addAction(cancelAction)
            present(optionMenu, animated: true, completion: nil)
        }
        else if passwordText.text != confirmPasswordText.text
        {
            let optionMenu = UIAlertController(title: "Sign Up Failed", message: "Password and confirm password texts should be same.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
                (UIAlertAction) in
             self.dismiss(animated: true, completion: nil)
            })
             optionMenu.addAction(cancelAction)
             present(optionMenu, animated: true, completion: nil)
        }
        else
        {
            guard let url = URL(string: URLStrings.CHANGE_PASSWORD) else { return }

            rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
            rest.httpBodyParameters.add(value:userNameText.text! , forKey: "Username")
            rest.httpBodyParameters.add(value: passwordText.text!, forKey: "Password")
            rest.httpBodyParameters.add(value: emailText.text! + schoolEmail.text!, forKey: "Email")
            rest.httpBodyParameters.add(value: schoolName, forKey: "SchoolName")
            rest.httpBodyParameters.add(value: self.avatarUploaded, forKey: "Avatar")
            rest.httpBodyParameters.add(value: self.imageURL ?? "", forKey: "Avatarimageurl")
            rest.httpBodyParameters.add(value: false, forKey: "TouchIdOn")

            rest.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
               //guard let response = results.response else { return }
                if results.response?.httpStatusCode == 200 {
                DispatchQueue.main.async {
                    let viewController = self.mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    let nav = UINavigationController(rootViewController: viewController)
                    UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = nav;
                }
               }
           }
        }
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = viewController;
    }
    
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePickerController(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageSize:CGSize = CGSize(width: 124, height: 125)
        if var editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            editedImage = resizeImage(image: editedImage, targetSize: imageSize)
            self.imageViewButton.setImage(editedImage, for: .normal)
        } else if var originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            originalImage = resizeImage(image: originalImage, targetSize: imageSize)
            self.imageViewButton.setImage(originalImage, for: .normal)
        }
        if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            let imgName = imgUrl.lastPathComponent
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            let localPath = documentDirectory?.appending(imgName)

            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            let data = image.pngData()! as NSData
            data.write(toFile: localPath!, atomically: true)
            //let imageData = NSData(contentsOfFile: localPath!)!
            let photoURL = URL.init(fileURLWithPath: localPath!)//NSURL(fileURLWithPath: localPath!)
            self.imageURL = photoURL.absoluteString
            self.avatarUploaded = true

        }
        dismiss(animated: true, completion: nil)
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height *      widthRatio)
        }

        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}
