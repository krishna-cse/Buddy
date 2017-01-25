//
//  ViewController.swift
//  Buddy
//
//  Created by Sai Krishna Dubagunta on 1/4/17.
//  Copyright © 2017 NJIT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet var registerButton: UIButton!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var imageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        let img = UIImage()
        self.navigationController?.navigationBar.shadowImage = img
        self.navigationController?.navigationBar.setBackgroundImage(img, for: .default)
        self.navigationController?.navigationBar.barTintColor = uicolorFromHex(rgbValue: 0xEE8624)
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0

        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.75, delay: 0.5, options: .curveEaseInOut, animations: {
            self.imageView.transform = CGAffineTransform.init(scaleX: 0.7, y: 0.7)
            self.imageView.transform = CGAffineTransform.init(translationX: 0, y: -100)
            self.registerButton.transform = CGAffineTransform.init(translationX: 0, y: -75)
            self.signInButton.transform = CGAffineTransform.init(translationX: 0, y: -75)
            self.signInButton.alpha = 1.0
            self.registerButton.alpha = 1.0
        }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

