//
//  LoginViewController.swift
//  Buddy
//
//  Created by Sai Krishna Dubagunta on 1/14/17.
//  Copyright © 2017 NJIT. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var signInButton: UIButton!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var njitIDField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
//        let img = UIImage()
//        self.navigationController?.navigationBar.shadowImage = img
//        self.navigationController?.navigationBar.setBackgroundImage(img, for: .default)
//        self.navigationController?.navigationBar.barTintColor = uicolorFromHex(rgbValue: 0xEE8624)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.njitIDField.layer.borderWidth = 1.0
        self.passwordField.layer.borderWidth = 1.0
        self.njitIDField.layer.cornerRadius = 5
        self.passwordField.layer.cornerRadius = 5
        self.njitIDField.layer.borderColor = UIColor.white.cgColor
        self.passwordField.layer.borderColor = UIColor.white.cgColor
        self.passwordField.attributedPlaceholder = NSAttributedString.init(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor.white])
        self.njitIDField.attributedPlaceholder = NSAttributedString.init(string: "NJIT Email", attributes: [NSForegroundColorAttributeName : UIColor.white])
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    @IBAction func signIn(_ sender: Any) {
        if Reachability.isConnectedToNetwork() == true {
            self.signIn()
        }
        else{
            DispatchQueue.main.async(execute: {
                //self.feedsTableView.hidden = true
                
                let toastLabel = UILabel(frame: CGRect(x : self.view.frame.size.width/2 - 90, y : self.view.frame.size.height-80, width : 90+90, height:  24))
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
        }
    }
    
    func signIn() {
        
        let email = njitIDField.text!
        let password = passwordField.text!
        
        if email == "" && password == "" {
            
            njitIDField.layer.borderColor = UIColor.red.cgColor
            njitIDField.layer.borderWidth = CGFloat(Float (1.0))
            
            passwordField.layer.borderColor = UIColor.red.cgColor
            passwordField.layer.borderWidth = CGFloat(Float (1.0))
            
            self.njitIDField.becomeFirstResponder()
        }
        else if email == "" || password == "" {
            
            if email == "" {
                njitIDField.layer.borderColor = UIColor.red.cgColor
                njitIDField.layer.borderWidth = CGFloat(Float (1.0))
                
                self.njitIDField.becomeFirstResponder()
            }
            if password == "" {
                passwordField.layer.borderColor = UIColor.red.cgColor
                passwordField.layer.borderWidth = CGFloat(Float (1.0))

                self.passwordField.becomeFirstResponder()
            }
        }
        else if email != "" && password != "" {
            
            let loginUrlString = "http://52.87.233.57:80/login"
            let loginUrl: NSURL = NSURL(string: loginUrlString)!
            
            let loginRequest: NSMutableURLRequest = NSMutableURLRequest(url: loginUrl as URL)
            loginRequest.httpMethod = "POST"
            let session = URLSession.shared
            
            let loginParams = ["email":email, "password":password] as Dictionary<String, String>
            loginRequest.httpBody = try! JSONSerialization.data(withJSONObject: loginParams, options: [])
            
            let task = session.dataTask(with: loginRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
                
                if error != nil {
                    print("error=\(error)")
                    DispatchQueue.main.async(execute: {
                        
                        let toastLabel = UILabel(frame: CGRect(x : self.view.frame.size.width/2 - 90, y:  self.view.frame.size.height-80, width:  90+90, height: 24))
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
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
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
                                        if response_code == 3 {
                                            self.njitIDField.becomeFirstResponder()
                                            self.njitIDField.isHidden = false
                                            self.njitIDField.text = "Please enter a valid NJIT email"
                                        }
                                        else if response_code == 5 {
                                            self.passwordField.becomeFirstResponder()
                                        }
                                        else if response_code == 1 {
                                            UserDefaults.standard.set(dict["uid"], forKey:"currentUser")
                                            UserDefaults.standard.set(dict["authorization"], forKey:"authorization")
                                            UserDefaults.standard.set(true, forKey: "isFirstTimeLogin")
                                            
                                            
                                            let viewController: UITabBarController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainAppID") as? UITabBarController
                                            //self.window?.rootViewController = viewController
                                            UIApplication.shared.keyWindow?.rootViewController = viewController
                                            self.dismiss(animated: true, completion: { 
                                              _ =  self.navigationController?.popToRootViewController(animated: true)
                                            })
                                        }
                                        else if response_code == -1 {
                                            
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
    }
    
    func isValidEmail(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@njit+\\.edu"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    @IBAction func njitIDFieldEditingChanged(sender: AnyObject) {
        if !isValidEmail(email: njitIDField.text!){
            njitIDField.layer.borderColor = UIColor.red.cgColor
            njitIDField.layer.borderWidth = CGFloat(Float (1.0))
            
        }
        else{
            njitIDField.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    @IBAction func passwordFieldEditingChanged(sender: AnyObject) {
        passwordField.layer.borderColor = UIColor.clear.cgColor
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if textField == self.njitIDField{
            self.njitIDField.resignFirstResponder()
            self.passwordField.becomeFirstResponder()
        }
        if textField == self.passwordField{
            self.passwordField.resignFirstResponder()
            if Reachability.isConnectedToNetwork() == true {
                self.signIn()
            } else {
                DispatchQueue.main.async(execute: {
                    
                    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 90, y : self.view.frame.size.height-320, width : 90+90, height : 24))
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
            }
        }
        return true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
    
    class func centerViewController() -> UITabBarController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "mainAppID") as? UITabBarController
    }
}
