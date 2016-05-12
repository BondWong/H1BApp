//
//  HistoryViewController.swift
//  H-1B
//
//  Created by Bond Wong on 12/31/15.
//  Copyright © 2015 Bond Wong. All rights reserved.
//

import UIKit

var history: [CLong: [String: AnyObject]] = {
    if let his:[CLong: [String: AnyObject]] = NSUserDefaults.standardUserDefaults().objectForKey("history") as? [CLong: [String: AnyObject]] {
        return his
    } else {
        return [:]
    }
}()

class HistoryViewController: UINavigationController, LocalDataDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let data = getData() as! CollectionResult
        let vc = self.viewControllers.first as! RecordsViewController
        vc.module = Module.HISTORY
        vc.delegate = self
        vc.data = data
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData() -> AnyObject {
        let data = CollectionResult()
        data.pageNum = 0
        data.pageSize = 50
        data.hasNext = false
        
        var positions = [Position]()
        for element in history.values {
            positions.append(createPosition(element))
        }
        
        data.positions = positions
        
        return data
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
