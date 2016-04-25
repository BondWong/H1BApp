//
//  AboutViewController.swift
//  H-1B
//
//  Created by Bond Wong on 12/28/15.
//  Copyright © 2015 Bond Wong. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let linkedin = NSURL(string: "https://www.linkedin.com/in/junbang-huang-3b304186?trk=nav_responsive_tab_profile")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let imageView = UIImageView(image: UIImage(named: "info"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.whiteColor()
        imageView.layer.cornerRadius = 50
        self.view.addSubview(imageView)
        imageView.widthAnchor.constraintEqualToAnchor(imageView.heightAnchor).active = true
        imageView.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor, multiplier: 1/10).active = true
        imageView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        imageView.topAnchor.constraintEqualToAnchor(self.topLayoutGuide.bottomAnchor, constant: UIScreen.mainScreen().bounds.height / 20).active = true
        
        let tableView = UITableView(frame: CGRectMake(0, UIScreen.mainScreen().bounds.height / 3, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height / 5))
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UIScreen.mainScreen().bounds.height / 15
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Developer: Junbang Huang"
        case 1:
            cell.textLabel?.text = "Version: 1.0.0"
        case 2:
            cell.textLabel?.text = "My LinkedIn"
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        default: break
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        switch indexPath.row {
        case 0, 1:
            return false
        default:
            return true
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 2 {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            UIApplication.sharedApplication().openURL(linkedin!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
