//
//  AboutViewController.swift
//  H1-B
//
//  Created by Bond Wong on 12/28/15.
//  Copyright © 2015 Bond Wong. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
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
