//
//  ItemDetailsVC.swift
//  PineHRMios
//
//  Created by Md Munir Hossain on 1/21/19.
//  Copyright © 2019 Md Munir Hossain. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class ItemDetailsVC: UIViewController {
    var item: ItemObject!
    @IBOutlet weak var title_lbl: UILabel!
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title_lbl.text = item.name
        // Do any additional setup after loading the view.
        if let accesstoken = KeychainWrapper.standard.string(forKey: Constants.KEY_TOKEN){
            webView.loadRequest(URLRequest(url: URL(string: item.url + accesstoken)!))
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btn_back_pressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
