//
//  ViewController.swift
//  PineHRMios
//
//  Created by Md Munir Hossain on 1/21/19.
//  Copyright © 2019 Md Munir Hossain. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire

class LoginVC: UIViewController {

    @IBOutlet weak var et_email: UITextField!
    @IBOutlet weak var et_password: UITextField!
    @IBOutlet weak var btn_login: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        let myColor = UIColor.white
        et_email.layer.borderColor = myColor.cgColor
        et_password.layer.borderColor = myColor.cgColor
        btn_login.layer.borderColor = myColor.cgColor

        et_email.layer.borderWidth = 1.0
        et_password.layer.borderWidth = 1.0
        btn_login.layer.borderWidth = 1.0
        
        et_email.setLeftPaddingPoints(10)
        et_password.setLeftPaddingPoints(10)
        
        et_email.attributedPlaceholder = NSAttributedString(string: "Email",
                                                               attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        et_password.attributedPlaceholder = NSAttributedString(string: "Password",
                                                            attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        //for test
        et_email.text = "salman.khan@canda.com"
        et_password.text = "hello"
    }

    @IBAction func login_pressed(_ sender: Any) {
        //check fields are empty or not
        if et_email.text?.isEmpty ?? true {
            print("email is empty")
            return
        } else {
            print("email has some text")
        }
        if et_password.text?.isEmpty ?? true {
            print("password is empty")
            return
        } else {
            print("password has some text")
        }
        login(email: et_email.text!, password: et_password.text!)
    }
    
    func login(email: String,password: String) {
        let parameters: Parameters = ["username": email,"password":password]
        print(Constants.login_url)
        Alamofire.request(Constants.login_url, method: .post, parameters: parameters)
            .responseString { response in
                print("String:\(response.result.value)")
                switch(response.result) {
                case .success(_):
                    if let data = response.result.value{
                        print(data)
                        do{
                            if let json = data.data(using: String.Encoding.utf8){
                                if let jsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String:AnyObject]{
                                    
                                    let accesstoken = jsonData["accesstoken"] as! String
                                    let name = jsonData["name"] as! String
                                    let email = jsonData["email"] as! String
                                
                                    KeychainWrapper.standard.set(accesstoken, forKey: Constants.KEY_TOKEN)
                                    KeychainWrapper.standard.set(name, forKey: Constants.KEY_NAME)
                                    KeychainWrapper.standard.set(email, forKey: Constants.KEY_EMAIL)
                                }
                            }
                        }catch {
                            print(error.localizedDescription)
                            
                        }
                        self.go_to_main_page()
                    }
                    
                case .failure(_):
                    print("Error message:\(response.result.error)")
                    break
                }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.LOGINVIEW_TO_MAINVC{
            if let dest: MainVC = segue.destination as? MainVC{
            }
        }
    }
    func go_to_main_page(){
        //
        performSegue(withIdentifier: Constants.LOGINVIEW_TO_MAINVC, sender: nil)
    }
}
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
