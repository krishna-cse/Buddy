//
//  NewPostViewController.swift
//  Buddy
//
//  Created by Sai Krishna Dubagunta on 1/19/17.
//  Copyright © 2017 NJIT. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = uicolorFromHex(rgbValue: 0xEE8624)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    @IBAction func doneButton(_ sender: UIButton) {
        
    }
    
    @IBAction func categoryButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Category", message: "Change your category of post here", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction.init(title: "All", style: .default, handler: nil))
        alert.addAction(UIAlertAction.init(title: "Confess", style: .default, handler: nil))
        alert.addAction(UIAlertAction.init(title: "Ask", style: .default, handler: nil))
        alert.addAction(UIAlertAction.init(title: "Vent", style: .default, handler: nil))
        alert.addAction(UIAlertAction.init(title: "Laugh", style: .default, handler: nil))
        alert.addAction(UIAlertAction.init(title: "Encourage", style: .default, handler: nil))
        alert.addAction(UIAlertAction.init(title: "Announce", style: .default, handler: nil))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
