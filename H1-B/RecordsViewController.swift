//
//  HistroyViewController.swift
//  H1-B
//
//  Created by Bond Wong on 12/30/15.
//  Copyright © 2015 Bond Wong. All rights reserved.
//

import UIKit

class RecordsViewController: UITableViewController {
    var module: Module!
    var data: [String: String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        switch module {
        case let m where m == Module.BOOKMARK:
            self.navigationItem.title = "Records"
        case let m where m == Module.SEARCH:
            self.navigationItem.title = "Records"
        default:
            self.navigationItem.title = "History"
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("record")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "record")
        }
        cell.textLabel?.text = "Record \(indexPath.row)"
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let vc: EmployerListViewController = segue.destinationViewController as! EmployerListViewController
        vc.module = self.module
    }
    
}
