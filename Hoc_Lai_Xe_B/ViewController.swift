//
//  ViewController.swift
//  Hoc_Lai_Xe_B
//
//  Created by Tam Vu on 08/04/2025.
//

import UIKit
import WebKit
import Combine

class ViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView1: WKWebView!
    @IBOutlet weak var selectBT: UIButton!
    //    var webView: WKWebView!
    
    var timer: Timer?
    var clickIndicator: UIView!
    
    
    @Published var isSelect: Bool = false
    
    var subscriptions = [AnyCancellable]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize WKWebView
        //        webView = WKWebView(frame: self.view.frame)
        webView1.navigationDelegate = self
        //        self.view.addSubview(webView)
        
        createClickIndicator()
        
        // Load the desired URL
        if let url = URL(string: "https://tuanlong.huelms.com/user/login/?logout=1") {
            let request = URLRequest(url: url)
            webView1.load(request)
        }
        
        self.$isSelect
            .sink(receiveValue: { [weak self] result in
                if result {
                    self?.startAutoClicking()
                } else {
                    self?.stopAutoClicking()
                }
            })
            .store(in: &subscriptions)
    }
    
    @IBAction func btAction(_ sender: Any) {
        isSelect.toggle()
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Start the timer to click the element every 2 seconds
        //        startAutoClicking()
    }
    
    func createClickIndicator() {
        clickIndicator = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        clickIndicator.backgroundColor = UIColor.red
        clickIndicator.layer.cornerRadius = 10
        self.view.addSubview(clickIndicator)
    }
    
    func startAutoClicking() {
        selectBT.backgroundColor = UIColor.green
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(autoClick), userInfo: nil, repeats: true)
    }
    
    @objc func autoClick() {
        var x = 340
        var y = 640
        
        clickIndicator.center = CGPoint(x: x, y: y)
        
        let js = "var evt = new MouseEvent('click', {clientX: \(x), clientY: \(y), bubbles: true}); document.elementFromPoint(\(x), \(y)).dispatchEvent(evt);"
        
        webView1.evaluateJavaScript(js) { (result, error) in
            if let error = error {
                print("a3....Error executing JavaScript: \(error)")
            } else {
                print("a3....Click simulated successfully.")
            }
        }
    }
    
    deinit {
        // Invalidate timer when the view controller is deallocated
        timer?.invalidate()
    }
    
    func stopAutoClicking() {
        selectBT.backgroundColor = UIColor.red
           timer?.invalidate()
           timer = nil // Clear the timer
       }
}

