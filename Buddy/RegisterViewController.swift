//
//  RegisterViewController.swift
//  Buddy
//
//  Created by Sai Krishna Dubagunta on 1/14/17.
//  Copyright © 2017 NJIT. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var verificationCodeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let img = UIImage()
        self.navigationController?.navigationBar.shadowImage = img
        self.navigationController?.navigationBar.setBackgroundImage(img, for: .default)
        self.navigationController?.navigationBar.barTintColor = uicolorFromHex(rgbValue: 0xEE8624)
        // Do any additional setup after loading the view.
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.emailTextField.layer.borderWidth = 1.0
        self.usernameTextField.layer.borderWidth = 1.0
        self.emailTextField.layer.cornerRadius = 5
        self.usernameTextField.layer.cornerRadius = 5
        self.emailTextField.layer.borderColor = UIColor.white.cgColor
        self.usernameTextField.layer.borderColor = UIColor.white.cgColor
        self.usernameTextField.attributedPlaceholder = NSAttributedString.init(string: "Username", attributes: [NSForegroundColorAttributeName : UIColor.white])
        self.emailTextField.attributedPlaceholder = NSAttributedString.init(string: "NJIT Email", attributes: [NSForegroundColorAttributeName : UIColor.white])
        self.passwordTextField.layer.borderWidth = 1.0
        self.confirmPasswordTextField.layer.borderWidth = 1.0
        self.passwordTextField.layer.cornerRadius = 5
        self.confirmPasswordTextField.layer.cornerRadius = 5
        self.passwordTextField.layer.borderColor = UIColor.white.cgColor
        self.confirmPasswordTextField.layer.borderColor = UIColor.white.cgColor
        self.confirmPasswordTextField.attributedPlaceholder = NSAttributedString.init(string: "Confirm Password", attributes: [NSForegroundColorAttributeName : UIColor.white])
        self.passwordTextField.attributedPlaceholder = NSAttributedString.init(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor.white])
        self.verificationCodeTextField.layer.borderWidth = 1.0
        self.verificationCodeTextField.layer.cornerRadius = 5
        self.verificationCodeTextField.layer.borderColor = UIColor.white.cgColor
        self.verificationCodeTextField.attributedPlaceholder = NSAttributedString.init(string: "Verification Code", attributes: [NSForegroundColorAttributeName : UIColor.white])
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isValidEmail(email:String) -> Bool {
        //let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailRegEx = "[A-Z0-9a-z._%+-]+@njit+\\.edu"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    @IBAction func sendVerificationCode(sender: AnyObject) {
        
        let email:String = emailTextField.text!
        
        if email != "" {
            
            if !isValidEmail(email: email){
                self.emailTextField.layer.borderColor = UIColor.red.cgColor
                self.emailTextField.layer.borderWidth = CGFloat(Float (1.0))
                
//                self.email_errorLabel.text = "Please enter a NJIT email"
            }
            else{
                
            }
            
            //verification process
            let verificationUrlString = "http://52.87.233.57:80/verification"
            let verificationUrl: NSURL = NSURL(string: verificationUrlString)!
            
            let verificationRequest: NSMutableURLRequest = NSMutableURLRequest(url: verificationUrl as URL)
            verificationRequest.httpMethod = "POST"
            let session = URLSession.shared
            
            // passing string in post request
            /*
             let requestParams = "email="+email
             verificationRequest.HTTPBody = requestParams.dataUsingEncoding(NSUTF8StringEncoding)
             verificationRequest.setValue("application/json", forHTTPHeaderField: "Accept");
             */
            
            let verificationParams = ["email":email] as Dictionary<String, String>
            verificationRequest.httpBody = try! JSONSerialization.data(withJSONObject: verificationParams, options: [])
            
            let task = session.dataTask(with: verificationRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
                
                if error != nil {
                    print("error=\(error)")
                   DispatchQueue.main.async(execute: {
                        
                    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 90, y: self.view.frame.size.height-320, width : 90+90, height : 24))
                        toastLabel.backgroundColor = UIColor.black
                        toastLabel.textColor = UIColor.white
                        toastLabel.font = UIFont(name: toastLabel.font.fontName, size: 14.5)
                        toastLabel.textAlignment = NSTextAlignment.center
                        toastLabel.text = "No internet connection."
                        toastLabel.alpha = 1.0
                        toastLabel.layer.cornerRadius = 4;
                        toastLabel.layer.borderColor = UIColor.white.cgColor
                        toastLabel.layer.borderWidth = CGFloat(Float (2.0))
                        toastLabel.clipsToBounds = true
                        
                        self.view.addSubview(toastLabel)
                        
                        UIView.animate(withDuration: 2.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations:{
                            
                            toastLabel.alpha = 0.0
                            
                        }, completion: nil)
                    })
                    return
                }
                
                print("Response: \(response)")
                let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("Body: \(strData)")
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                    if let dict = json as? NSDictionary {
                        // ... process the data
                        print(dict)
                        //var msg = "No message"
                        
                        // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
                        if(error != nil) {
                            print(error!.localizedDescription)
                            let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                            print("Error could not parse JSON: '\(jsonStr)'")
                            //postCompleted(succeeded: false, msg: "Error")
                        }
                        else {
                            
                            // The JSONObjectWithData constructor didn't return an error. But, we should still
                            // check and make sure that json has a value using optional binding.
                            if let dict = json as? NSDictionary {
                                // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                                if let response_code = dict["response_code"] as? Int {
                                    print("response_code: \(response_code)")
                                    //postCompleted(succeeded: success, msg: "Logged in.")
                                    DispatchQueue.main.async(execute: {
                                        if response_code == 2 {
                                            
//                                            self.email_errorLabel.text = "This email is in use"
                                            
                                            self.emailTextField.layer.borderColor = UIColor.red.cgColor
                                            self.emailTextField.layer.borderWidth = CGFloat(Float (1.0))
                                        }
                                        if response_code == 3 {

//                                            self.email_errorLabel.text = "Email not valid. Please use NJIT email."
                                            
                                            self.emailTextField.layer.borderColor = UIColor.red.cgColor
                                            self.emailTextField.layer.borderWidth = CGFloat(Float (1.0))
                                        }
                                            
                                        else if response_code == 101 {
                                            //MAIL_SENDING_TOO_FREQUENT
                                            let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 100, y: self.view.frame.size.height-320, width : 200, height : 24))
                                            toastLabel.backgroundColor = UIColor.black
                                            toastLabel.textColor = UIColor.white
                                            toastLabel.font = UIFont(name: toastLabel.font.fontName, size: 15)
                                            toastLabel.textAlignment = NSTextAlignment.center
                                            self.view.addSubview(toastLabel)
                                            //change
                                            toastLabel.text = "Mail sent too frequently."
                                            toastLabel.alpha = 1.0
                                            toastLabel.layer.cornerRadius = 5;
                                            toastLabel.clipsToBounds  =  true
                                            
                                            UIView.animate(withDuration: 4.0, delay: 0.1, options: UIViewAnimationOptions.curveEaseOut, animations:{
                                                
                                                toastLabel.alpha = 0.0
                                                
                                            }, completion: nil)
                                        }
                                    })
                                }
                                return
                                
                            }
                            else {
                                // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                                let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                print("Error could not parse JSON: \(jsonStr)")
                                //postCompleted(succeeded: false, msg: "Error")
                            }
                        }
                    }
                } catch let error as NSError {
                    print("An error occurred: \(error)")
                }
            })
            task.resume()
        }
        else{
            
        }
    }
    
    @IBAction func registerButtonClicked(sender: AnyObject) {
        
        let email = emailTextField.text!
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        let confirm_password = confirmPasswordTextField.text!
        let verification = self.verificationCodeTextField.text!
        
        let red_color : UIColor = UIColor.red
        if email == "" && username == "" && password == "" && confirm_password == "" && verification == "" {
           
//            self.email_errorLabel.text = "All fields are required"
            
            self.emailTextField.layer.borderColor = UIColor.red.cgColor
            self.emailTextField.layer.borderWidth = CGFloat(Float (1.0))
            
            self.usernameTextField.layer.borderColor = red_color.cgColor
            self.usernameTextField.layer.borderWidth = CGFloat(Float (1.0))
            
            self.passwordTextField.layer.borderColor = red_color.cgColor
            self.passwordTextField.layer.borderWidth = CGFloat(Float (1.0))
            
            self.confirmPasswordTextField.layer.borderColor = red_color.cgColor
            self.confirmPasswordTextField.layer.borderWidth = CGFloat(Float (1.0))
            
            self.verificationCodeTextField.layer.borderColor = red_color.cgColor
            self.verificationCodeTextField.layer.borderWidth = CGFloat(Float (1.0))
            
            /*
             let toastLabel = UILabel(frame: CGRectMake(self.view.frame.size.width/2 - 130, self.view.frame.size.height-80, 260, 24))
             toastLabel.backgroundColor = UIColor.black
             toastLabel.textColor = UIColor.white
             toastLabel.font = UIFont(name: toastLabel.font.fontName, size: 15)
             toastLabel.textAlignment = NSTextAlignment.Center;
             self.view.addSubview(toastLabel)
             toastLabel.text = "You have been successfully registered."
             toastLabel.alpha = 1.0
             toastLabel.layer.cornerRadius = 5;
             toastLabel.clipsToBounds  =  true
             
             UIView.animateWithDuration(4.0, delay: 0.1, options: UIViewAnimationOptions.CurveEaseOut, animations:{
             
             toastLabel.alpha = 0.0
             
             }, completion: {(completed) in
             
             let viewController: UIViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController")
             let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
             appDelegate.window?.rootViewController = viewController
             self.navigationController?.popToRootViewControllerAnimated(true)
             })
             */
            return
        }
            
        else if email == "" || username == "" || password == "" || verification == ""{
            
            if !isValidEmail(email: email){
                self.emailTextField.layer.borderColor = red_color.cgColor
                self.emailTextField.layer.borderWidth = CGFloat(Float (1.0))
                
               
//                self.email_errorLabel.text = "Please enter a NJIT email"
            }
            
            if username == ""{
                self.usernameTextField.layer.borderColor = red_color.cgColor
                self.usernameTextField.layer.borderWidth = CGFloat(Float (1.0))
                

//                self.username_errorLabel.text = "Username cannot be empty"
            }
            
            if password == ""{
                self.passwordTextField.layer.borderColor = red_color.cgColor
                self.passwordTextField.layer.borderWidth = CGFloat(Float (1.0))
                
                
//                self.password_errorLabel.text = "Password cannot be empty"
            }
            else{
                self.passwordTextField.layer.borderColor = UIColor.clear.cgColor
            }
            
            if confirm_password == ""{
                self.confirmPasswordTextField.layer.borderColor = red_color.cgColor
                self.confirmPasswordTextField.layer.borderWidth = CGFloat(Float (1.0))
                
                
//                self.confrimPassword_errorLabel.text = "Confirm password cannot be empty"
            }
            else{
                self.confirmPasswordTextField.layer.borderColor = UIColor.clear.cgColor
            }
            
            if verification == "" {
                self.verificationCodeTextField.layer.borderColor = red_color.cgColor
                self.verificationCodeTextField.layer.borderWidth = CGFloat(Float (1.0))
                
//                self.verificationCode_errorLabel.text = "Enter Verification Code"
            }
            
            if password != confirm_password{
                if password != "" && confirm_password == ""{
                    self.confirmPasswordTextField.layer.borderColor = red_color.cgColor
                    self.confirmPasswordTextField.layer.borderWidth = CGFloat(Float (1.0))
                    
//                    self.confrimPassword_errorLabel.text = "Confirm password cannot be empty"
                }
                else if password == "" && confirm_password != ""{
                    self.passwordTextField.layer.borderColor = red_color.cgColor
                    self.passwordTextField.layer.borderWidth = CGFloat(Float (1.0))
                    
//                    self.password_errorLabel.text = "Password cannot be empty"
                }
                else{
                    self.passwordTextField.layer.borderColor = UIColor.clear.cgColor
                    self.confirmPasswordTextField.layer.borderColor = UIColor.red.cgColor
                    
//                    self.confrimPassword_errorLabel.text = "Password does not match"
                }
            }
            else {
                if password == "" && confirm_password == "" {
                    self.passwordTextField.layer.borderColor = red_color.cgColor
                    self.passwordTextField.layer.borderWidth = CGFloat(Float (1.0))
                    
//                    self.password_errorLabel.text = "Password cannot be empty"
                    
                    self.confirmPasswordTextField.layer.borderColor = red_color.cgColor
                    self.confirmPasswordTextField.layer.borderWidth = CGFloat(Float (1.0))
                    
//                    self.confrimPassword_errorLabel.text = "Confirm password cannot be empty"
                }
                else{
                    self.passwordTextField.layer.borderColor = UIColor.clear.cgColor
                    self.confirmPasswordTextField.layer.borderColor = UIColor.clear.cgColor
                }
            }
        }
        else if email != "" && username != "" && password != "" && verification != "" {
            if password != confirm_password{
                if password != "" && confirm_password == ""{
                    self.confirmPasswordTextField.layer.borderColor = red_color.cgColor
                    self.confirmPasswordTextField.layer.borderWidth = CGFloat(Float (1.0))
                    
//                    self.confrimPassword_errorLabel.text = "Confirm password cannot be empty"
                }
                else if password == "" && confirm_password != ""{
                    self.passwordTextField.layer.borderColor = red_color.cgColor
                    self.passwordTextField.layer.borderWidth = CGFloat(Float (1.0))
                    
                
//                    self.password_errorLabel.text = "Password cannot be empty"
                }
                else{
                    self.passwordTextField.layer.borderColor = UIColor.clear.cgColor
                    self.confirmPasswordTextField.layer.borderColor = UIColor.clear.cgColor
                  
                    
                  
//                    self.confrimPassword_errorLabel.text = "Password does not match"
                }
            }
            else{
                registrationProcess(email: email, username: username, password: password, verification: verification)
            }
        }
    }

    func registrationProcess(email: String, username: String, password: String, verification: String)
    {
        let registerationUrlString = "http://52.87.233.57:80/register"
        let registerationUrl: NSURL = NSURL(string: registerationUrlString)!
        
        let registerationRequest: NSMutableURLRequest = NSMutableURLRequest(url: registerationUrl as URL)
        registerationRequest.httpMethod = "POST"
        let session = URLSession.shared
        
        // when dictionary is used !
        
        //        let resgistrationParams : NSString = "email="+email+"username="+username+"password="+password+"verification"+verification
        //        registerationRequest.HTTPBody = resgistrationParams.dataUsingEncoding(NSUTF8StringEncoding)
        //        registerationRequest.setValue("application/json", forHTTPHeaderField: "Accept");
        
        let resgistrationParams = ["email":email, "username":username, "password":password, "verification":verification] as Dictionary<String, String>
        registerationRequest.httpBody = try! JSONSerialization.data(withJSONObject: resgistrationParams, options: [])
        
        let task = session.dataTask(with: registerationRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    //self.feedsTableView.hidden = true
                    
                    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 90, y: self.view.frame.size.height-320, width : 90+90, height : 24))
                    toastLabel.backgroundColor = UIColor.black
                    toastLabel.textColor = UIColor.white
                    toastLabel.font = UIFont(name: toastLabel.font.fontName, size: 14.5)
                    toastLabel.textAlignment = NSTextAlignment.center;
                    toastLabel.text = "No internet connection."
                    toastLabel.alpha = 1.0
                    toastLabel.layer.cornerRadius = 4;
                    toastLabel.layer.borderColor = UIColor.white.cgColor
                    toastLabel.layer.borderWidth = CGFloat(Float (2.0))
                    toastLabel.clipsToBounds = true
                    
                    self.view.addSubview(toastLabel)
                    
                    UIView.animate(withDuration: 2.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations:{
                        
                        toastLabel.alpha = 0.0
                        
                    }, completion: nil)
                })
                return
            }
            
            print("Response: \(response)")
            let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("Body: \(strData)")
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                if let dict = json as? NSDictionary {
                    // ... process the data
                    print(dict)
                    //var msg = "No message"
                    
                    // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
                    if(error != nil) {
                        print(error!.localizedDescription)
                        let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        print("Error could not parse JSON: '\(jsonStr)'")
                        //postCompleted(succeeded: false, msg: "Error")
                    }
                    else {
                        
                        // The JSONObjectWithData constructor didn't return an error. But, we should still
                        // check and make sure that json has a value using optional binding.
                        if let dict = json as? NSDictionary {
                            // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                            if let response_code = dict["response_code"] as? Int {
                                print("response_code: \(response_code)")
                                
                                DispatchQueue.main.async(execute: {
                                    if response_code == 1 {
                                        
                                        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 140, y : self.view.frame.size.height-80, width : 285,  height : 24))
                                        toastLabel.backgroundColor = UIColor.black
                                        toastLabel.textColor = UIColor.white
                                        toastLabel.font = UIFont(name: toastLabel.font.fontName, size: 15)
                                        toastLabel.textAlignment = NSTextAlignment.center;
                                        self.view.addSubview(toastLabel)
                                        //change
                                        toastLabel.text = "You have been successfully registered."
                                        toastLabel.alpha = 1.0
                                        toastLabel.layer.cornerRadius = 5;
                                        toastLabel.clipsToBounds  =  true
                                        
                                        UIView.animate(withDuration: 4.0, delay: 0.1, options: UIViewAnimationOptions.curveEaseOut, animations:{
                                            
                                            toastLabel.alpha = 0.0
                                            
                                        }, completion: {(completed) in
                                            
                                            let viewController: UIViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
                                            UIApplication.shared.keyWindow?.rootViewController = viewController
                                            _ = self.navigationController?.popToRootViewController(animated: true)
                                        })
                                    }
                                    else if response_code == 2 {
                                        
                                        self.emailTextField.layer.borderColor = UIColor.red.cgColor
                                        self.emailTextField.layer.borderWidth = CGFloat(Float (1.0))
                                    }
                                    else if response_code == 3 {
                                        
//                                        self.email_errorLabel.text = "Email not valid. Please use NJIT email."
                                        
                                        self.emailTextField.layer.borderColor = UIColor.red.cgColor
                                        self.emailTextField.layer.borderWidth = CGFloat(Float (1.0))
                                    }
                                    else if response_code == 4 {
                                        
//                                        self.password_errorLabel.text = "Password must be atleast 8 chararters long"
                                        
                                        self.passwordTextField.layer.borderColor = UIColor.red.cgColor
                                        self.passwordTextField.layer.borderWidth = CGFloat(Float (1.0))
                                    }
                                    else if response_code == 8 {
                                        
//                                        self.self.verificationCode_errorLabel.text = "Verification code does not match"
                                        
                                        self.self.verificationCodeTextField.layer.borderColor = UIColor.red.cgColor
                                        self.self.verificationCodeTextField.layer.borderWidth = CGFloat(Float (1.0))
                                    }
                                    else if response_code == 9 {
                                        //Verification code has expired.
                                        let toastLabel = UILabel(frame: CGRect(x : self.view.frame.size.width/2 - 115, y : self.view.frame.size.height-320, width :230, height : 24))
                                        toastLabel.backgroundColor = UIColor.black
                                        toastLabel.textColor = UIColor.white
                                        toastLabel.font = UIFont(name: toastLabel.font.fontName, size: 15)
                                        toastLabel.textAlignment = NSTextAlignment.center
                                        self.view.addSubview(toastLabel)
                                        //change
                                        toastLabel.text = "Verification code has expired."
                                        toastLabel.alpha = 1.0
                                        toastLabel.layer.cornerRadius = 5;
                                        toastLabel.clipsToBounds  =  true
                                        
                                        UIView.animate(withDuration: 4.0, delay: 0.1, options: UIViewAnimationOptions.curveEaseOut, animations:{
                                            
                                            toastLabel.alpha = 0.0
                                            
                                        }, completion: nil)
                                    }
                                })
                            }
                            return
                        }
                        else {
                            // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                            let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                            print("Error could not parse JSON: \(jsonStr)")
                            //postCompleted(succeeded: false, msg: "Error")
                        }
                    }
                }
            } catch let error as NSError {
                print("An error occurred: \(error)")
            }
        })
        task.resume()
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
