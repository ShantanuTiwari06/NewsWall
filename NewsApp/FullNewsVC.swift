//
//  FullNewsVC.swift
//  NewsApp
//
//  Created by Shantanu Tiwari on 23/09/20.
//  Copyright © 2020 Shantanu Tiwari. All rights reserved.
//

import UIKit
import WebKit

class FullNewsVC: UIViewController,WKNavigationDelegate {

    // MARK:- Outlets
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var loader:UIActivityIndicatorView!
    var newsUrl = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webview.navigationDelegate = self
        
        guard let url = URL(string: newsUrl) else{
            return
        }
        webview.load(URLRequest(url: url))
        webview.allowsBackForwardNavigationGestures = true
        
        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
