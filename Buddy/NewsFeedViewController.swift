//
//  NewsFeedViewController.swift
//  Buddy
//
//  Created by Sai Krishna Dubagunta on 1/5/17.
//  Copyright © 2017 NJIT. All rights reserved.
//

import UIKit

class NewsFeedViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UITabBarDelegate {
    
    @IBOutlet weak var nav: UINavigationItem!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var scroll: UIScrollView!
    let postControl = postController()
    var categoryType : segementControllerClass! = nil
    var postsArray = NSMutableArray()
    var i = 0;
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        scroll.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 40)
        categoryType = segementControllerClass(frame: CGRect(x: 0, y: 0, width: 700, height: scroll.frame.size.height))
        categoryType.thumbColor = UIColor.white
        categoryType.backgroundColor = uicolorFromHex(rgbValue: 0xEE8624)
        categoryType.selectedLabelColor = UIColor.white
        scroll.addSubview(categoryType)
        scroll.backgroundColor = uicolorFromHex(rgbValue: 0xEE8624)
        scroll.contentSize = categoryType.frame.size
        categoryType.items = ["All","Confess","Ask","Vent","Laugh","Encourage","Announce"]
        categoryType.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        let img = UIImage()
        self.navigationController?.navigationBar.shadowImage = img
        self.navigationController?.navigationBar.setBackgroundImage(img, for: .default)
        self.navigationController?.navigationBar.barTintColor = uicolorFromHex(rgbValue: 0xEE8624)
        self.table.delegate = self
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            self.table.refreshControl = refreshControl
        }
        else {
            table.backgroundView = refreshControl
        }
    }
    
    
    func refresh(_ refreshControl : UIRefreshControl) {
        refreshControl.beginRefreshing()
        if Reachability.isConnectedToNetwork() {
            fetchPosts(page: 0, category: categoryType.selectedIndex-1, sender: "valueChanged")
            self.table.reloadData()
        }
        else {
            self.showAlert(errorString: "No internet connection")
        }
        refreshControl.endRefreshing()
    }
    
    func valueChanged() {
        if Reachability.isConnectedToNetwork() {
            fetchPosts(page : 0, category: categoryType.selectedIndex-1, sender: "valueChanged")
            self.table.reloadData()
        }
        else
        {
            self.showAlert(errorString: "No internet connection")
        }

    }
    
    func showAlert(errorString : String){
        let alert = UIAlertController.init(title: "Error", message: errorString, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Ok", style: .cancel, handler: nil))
        self.show(alert, sender: self)
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if Reachability.isConnectedToNetwork() {
         fetchPosts(page : 0 , category: categoryType.selectedIndex-1,sender: "")
         self.table.reloadData()
        }
        else {
            self.showAlert(errorString: "No internet connection")
        }
    }
    
    
    func fetchPosts(page: Int, category : Int, sender: String) {

        self.postControl.connectionRequest(page: page, category: category, attention: 0, target_uid: 0) { (variableArray) in
            switch variableArray.count {
            case 1:
                switch variableArray[0] as! Int {
                case -1:
                    self.showAlert(errorString: "No internet connection")
                    break;
                case 100:
                    self.showAlert(errorString: "Login required")
                    break;
                case -5 :
                    self.showAlert(errorString: "Not Authorized")
                    break;
                default:
                    break;
                }
                break;
            default:
                if sender != "valueChanged"{
                    self.postsArray.addObjects(from: variableArray)
                    self.table.reloadData()
                }
                else {
                    self.postsArray.removeAllObjects()
                    self.postsArray.addObjects(from: variableArray)
                    self.table.reloadData()
                }
                break;
            }

        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        return postsArray.count

        return postsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : PostCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PostCell
        let thisDict = self.postsArray.object(at: indexPath.row) as! NSDictionary
        cell.usernameLabel.text = thisDict.object(forKey: "username") as? String
        cell.postLabel.text = thisDict.object(forKey: "content") as? String
        
        if thisDict.object(forKey: "uid") as! Int != UserDefaults.standard.object(forKey: "currentUser") as! Int {
            cell.flagButton.addTarget(self, action: #selector(sendAction(_:)), for: .touchUpInside)
            cell.bellButton.addTarget(self, action: #selector(sendAction(_:)), for: .touchUpInside)
            cell.hugButton.addTarget(self, action: #selector(sendAction(_:)), for: .touchUpInside)
            cell.usernameButton.addTarget(self, action: #selector(nameClicked(_:)), for: .touchUpInside)
        }
        else{
            cell.hugButton.addTarget(self, action: #selector(hugsButtonClicked(_:)), for: .touchUpInside)
            cell.usernameButton.addTarget(self, action: #selector(goToAccount), for: .touchUpInside)
        }
        
        cell.commentButton.addTarget(self, action: #selector(commentButtonClicked(_:)), for: .touchUpInside)
        
        switch (thisDict.object(forKey: "category") as! Int) {
        case 0:
            cell.commentButton.isHidden = true
            cell.commentCountLabel.isHidden = true
            cell.bellButton.isHidden = false

            break
        case 1:
            cell.commentButton.isHidden = false
            cell.commentCountLabel.isHidden = false
            if thisDict.object(forKey: "comments") as! Int > 0 {
             cell.commentCountLabel.text = "\((thisDict.object(forKey: "comments") as! Int))"
            }
            cell.bellButton.isHidden = true
            break
        case 2 :
            cell.commentButton.isHidden = true
            cell.commentCountLabel.isHidden = true
            cell.bellButton.isHidden = false
            
            break
        case 3 :
            cell.commentButton.isHidden = true
            cell.commentCountLabel.isHidden = true
            cell.bellButton.isHidden = false
            break
        case 4:
            cell.commentButton.isHidden = true
            cell.commentCountLabel.isHidden = true
            cell.bellButton.isHidden = false
            break
        case 5:
            cell.commentButton.isHidden = true
            cell.commentCountLabel.isHidden = true
            cell.bellButton.isHidden = false
            break
        default:
            break
        }
        
        
        cell.bellButton.tag = thisDict.object(forKey: "pid") as! Int
        cell.hugButton.tag = thisDict.object(forKey: "pid") as! Int
        cell.flagButton.tag = thisDict.object(forKey: "pid") as! Int
        
        // Hug
        if thisDict.object(forKey: "hugged") as! Int == 1 {
            cell.hugCountLabel.isHidden = false
            cell.hugCountLabel.text = "\((thisDict.object(forKey: "hugs") as! Int))"
            cell.hugButton.setImage(#imageLiteral(resourceName: "ic_hug_selected"), for: .normal)
            UserDefaults.standard.set(true, forKey:"\(thisDict.object(forKey: "pid") as! Int)_hug")
        }
        else{
            cell.hugButton.setImage(#imageLiteral(resourceName: "ic_hug_unselected"), for: .normal)
            cell.hugCountLabel.isHidden = true
            UserDefaults.standard.set(false, forKey:"\(thisDict.object(forKey: "pid") as! Int)_hug")
        }
        
        //Flag 
        if thisDict.object(forKey: "flagged") as! Int == 1 {
            cell.flagButton.setImage(#imageLiteral(resourceName: "ic_flag_selected"), for: .normal)
            UserDefaults.standard.set(true, forKey:"\(thisDict.object(forKey: "pid") as! Int)_flag")
        }
        else{
            cell.flagButton.setImage(#imageLiteral(resourceName: "ic_flag_unselected"), for: .normal)
            UserDefaults.standard.set(false, forKey:"\(thisDict.object(forKey: "pid") as! Int)_flag")
        }
        
        // Bell
        if thisDict.object(forKey: "belled") as! Int == 1 {
            cell.bellButton.setImage(#imageLiteral(resourceName: "ic_bell_selected"), for: .normal)
            UserDefaults.standard.set(true, forKey:"\(thisDict.object(forKey: "pid") as! Int)_bell")
        }
        else {
            cell.bellButton.setImage(#imageLiteral(resourceName: "ic_bell_unselected"), for: .normal)
            UserDefaults.standard.set(false, forKey:"\(thisDict.object(forKey: "pid") as! Int)_bell")
        }
        
        cell.timeStampLabel.text = "\u{1F557}" + postControl.calculateTimeGap(unixTime: (thisDict.object(forKey: "timestamp") as? Double)!)

        return cell
    }
    

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if indexPath.row+1 == self.postsArray.count {
            if self.i == 0 {
                self.i += 1
            }
            else if self.i > 0 {
                if Reachability.isConnectedToNetwork() {
                    self.fetchPosts(page: self.i, category: self.categoryType.selectedIndex-1, sender: "")
                    self.i = i + 1
                }
                else {
                    self.showAlert(errorString: "No internet connection")
                }
            }
        }
    
    }
    
    func returnImage(labelText : String!) -> UIImage {
        switch labelText {
            case "bell_selected":
                return #imageLiteral(resourceName: "ic_bell_selected")
            case "bell_unselected" :
                return #imageLiteral(resourceName: "ic_bell_unselected")
            case "hug_selected" :
                return #imageLiteral(resourceName: "ic_hug_selected")
            case "hug_unselected":
                return #imageLiteral(resourceName: "ic_hug_unselected")
            case "flag_selected" :
                return #imageLiteral(resourceName: "ic_flag_selected")
            case "flag_unselected":
                return #imageLiteral(resourceName: "ic_flag_unselected")
            default:
                return UIImage()
        }
    }

    
    func sendAction(_ sender: UIButton) {
        
        postControl.flag_bell_hug_postRequest(sender: [sender.tag, (sender.titleLabel?.text)!]) { (result) in
            switch result {
            case 0:
                break
            case 1:
                UserDefaults.standard.set(true, forKey: "\(sender.tag)_\((sender.titleLabel?.text)!)")
                sender.setImage(self.returnImage(labelText: "\((sender.titleLabel?.text)!)_selected"), for: .normal)
                break
            case 2:
                UserDefaults.standard.set(false, forKey: "\(sender.tag)_\((sender.titleLabel?.text)!)")
                sender.setImage(self.returnImage(labelText: "\((sender.titleLabel?.text)!)_unselected"), for: .normal)
                break
            default:
                break
            }
        }
    }
    
    func hugsButtonClicked(_ sender: Any)  {
        
    }
    
    func commentButtonClicked(_ sender: Any)  {
        self.performSegue(withIdentifier: "newsComments", sender: self)
    }
    
    func goToAccount() {
        self.tabBarController?.selectedIndex = 2
        
    }
    
    func nameClicked(_ sender: Any)  {
        
        self.performSegue(withIdentifier: "newsAccount", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
