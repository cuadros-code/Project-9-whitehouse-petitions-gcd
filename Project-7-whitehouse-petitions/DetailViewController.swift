//
//  DetailViewController.swift
//  Project-7-whitehouse-petitions
//
//  Created by Kevin Cuadros on 16/08/24.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        guard let detailItem = detailItem else { return }
        
        let html = """
        <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <style> body { font-size: 150%; font-family: system-ui; } </style>
            </head>
            <body>
            \(detailItem.body)
            </body>
        </html>
        """
        webView.loadHTMLString(html, baseURL: nil)
        
    }
    
}
