//
//  CommentViewController.swift
//  Buddy
//
//  Created by Sai Krishna Dubagunta on 1/18/17.
//  Copyright © 2017 NJIT. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var table: UITableView!
    var pID: Int!
    var page = 0
    @IBOutlet var commentTextField: UITextField!
    var reverseArray : NSArray!
    var commentsArray: NSMutableArray = []
    
    var postDictionary : NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        return cell!
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
