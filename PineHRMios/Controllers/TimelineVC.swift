//
//  TimelineVC.swift
//  PineHRMios
//
//  Created by Md Munir Hossain on 3/14/19.
//  Copyright © 2019 Md Munir Hossain. All rights reserved.
//

import UIKit

class TimelineVC: UIViewController , UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet var loadSpinner: UIActivityIndicatorView!
    let timeline_url: String = "https://www.pinehrm.com"
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        // Do any additional setup after loading the view.
        webView.loadRequest(URLRequest(url: URL(string: timeline_url)!))
    }
    

    func webViewDidStartLoad(_ : UIWebView) {
        loadSpinner.startAnimating()
        loadSpinner.isHidden = false;
    }
    
    func webViewDidFinishLoad(_ : UIWebView) {
        loadSpinner.stopAnimating()
        loadSpinner.isHidden = true;
    }

}
