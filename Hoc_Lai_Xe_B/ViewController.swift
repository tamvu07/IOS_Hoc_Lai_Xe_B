//
//  ViewController.swift
//  Hoc_Lai_Xe_B
//
//  Created by Tam Vu on 08/04/2025.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize WKWebView
        webView = WKWebView(frame: self.view.frame)
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        
        // Load the desired URL
        if let url = URL(string: "https://tuanlong.huelms.com/user/login/?logout=1") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Start the timer to click the element every 2 seconds
        startAutoClicking()
    }
    
    func startAutoClicking() {
        timer = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(autoClick), userInfo: nil, repeats: true)
    }
    
    @objc func autoClick() {
        
        // Thay đổi tọa độ x và y theo nhu cầu của bạn
                let x = 10 // Tọa độ x
                let y = 10 // Tọa độ y
                let js = "var evt = new MouseEvent('click', {clientX: \(x), clientY: \(y), bubbles: true}); document.elementFromPoint(\(x), \(y)).dispatchEvent(evt);"
                
                webView.evaluateJavaScript(js) { (result, error) in
                    if let error = error {
                        print("a3....Error executing JavaScript: \(error)")
                    } else {
                        print("a3....Click simulated successfully.")
                    }
                }
        
//        let js = "document.querySelector('YOUR_SELECTOR').click();"
//        webView.evaluateJavaScript(js) { (result, error) in
//            if let error = error {
//                print("a3....Error executing JavaScript: \(error)")
//            } else {
//                print("a3...Click simulated successfully.")
//            }
//        }
    }
    
    deinit {
        // Invalidate timer when the view controller is deallocated
        timer?.invalidate()
    }
}

