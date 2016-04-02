//
//  BookmarkViewController.swift
//  H1-B
//
//  Created by Bond Wong on 12/28/15.
//  Copyright © 2015 Bond Wong. All rights reserved.
//

import UIKit

class BookmarkViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let vc:EmployerListViewController =  self.viewControllers.first as! EmployerListViewController
        vc.module = .BOOKMARK
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
    }*/

}
