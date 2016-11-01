//
//  postStatusViewController.swift
//  tweety
//
//  Created by Abhinav Rai on 10/31/16.
//  Copyright © 2016 Abhinav Rai. All rights reserved.
//

import UIKit

class postStatusViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBAction func onPostTap(_ sender: AnyObject) {
        let status = self.textView.text
        print("going to tweet: \(status)")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.text = nil

        // Do any additional setup after loading the view.
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
