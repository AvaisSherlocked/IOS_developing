//
//  BusinessDetailViewController.swift
//  CouponGo
//
//  Created by Ava on 3/6/19.
//  Copyright © 2019 CouponGo. All rights reserved.
//

import UIKit
import WebKit

class BusinessDetailViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityInd: UIActivityIndicatorView!
    var url: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        let myURL = URL(string: url!)
        let myRequest = URLRequest(url: myURL!)
        webView.isHidden = false
        webView.load(myRequest)
        webView.navigationDelegate = self
        // Do any additional setup after loading the view.
    }
    // start navigation
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)
    {
        self.activityInd.isHidden = false
        self.activityInd.startAnimating()
    }
    // finish loading
    func webView(_ webView: WKWebView, didFinish: WKNavigation!){
        self.activityInd.stopAnimating()
        self.activityInd.isHidden = true
    }
    // loading failed
    func webView(_ webView: WKWebView,
                 didFailProvisionalNavigation navigation: WKNavigation!,
                 withError error: Error){
        self.activityInd.isHidden = true
        self.webView.isHidden = true
        print("Oops, some thing went wrong")
        
    }

}
