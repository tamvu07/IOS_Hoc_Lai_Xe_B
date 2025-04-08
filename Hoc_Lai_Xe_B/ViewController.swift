//
//  ViewController.swift
//  Hoc_Lai_Xe_B
//
//  Created by Tam Vu on 08/04/2025.
//

import UIKit
import WebKit
import Combine

struct PointObject {
    var x: Int = 0
    var y: Int = 0
}

class ViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView1: WKWebView!
    @IBOutlet weak var selectBT: UIButton!
    //    var webView: WKWebView!
    
    var timerPoint: Timer?
    var clickIndicator: UIView!
    var arrayPoints: [PointObject] = [PointObject(x: 150, y: 150), PointObject(x: 150, y: 200), PointObject(x: 250, y: 0), PointObject(x: 150, y: 300), PointObject(x: 150, y: 350)]
    var timerNext: Timer?
    
    
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
        timerPoint = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(autoClick), userInfo: nil, repeats: true)
        timerNext = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(autoNext), userInfo: nil, repeats: true)
    }
    
    @objc func autoClick() {
        for item in arrayPoints {
            numberPointSelect(x: item.x, y: item.y)
        }
    }
    
    @objc func autoNext() {
        nextAction()
    }
    
    func numberPointSelect(x: Int, y: Int) {
        clickIndicator.center = CGPoint(x: x, y: y)
        
        let js = "var evt = new MouseEvent('click', {clientX: \(x), clientY: \(y), bubbles: true}); document.elementFromPoint(\(x), \(y)).dispatchEvent(evt);"
        
        webView1.evaluateJavaScript(js) { (result, error) in
            if let error = error {
                print("a3....Error number PointSelect: \(error)")
            } else {
                print("a3....number PointSelect Click.")
            }
        }
    }
    
    func nextAction() {
        var x = 340
        var y = 640
        
        clickIndicator.center = CGPoint(x: x, y: y)
        
        let js = "var evt = new MouseEvent('click', {clientX: \(x), clientY: \(y), bubbles: true}); document.elementFromPoint(\(x), \(y)).dispatchEvent(evt);"
        
        webView1.evaluateJavaScript(js) { (result, error) in
            if let error = error {
                print("a4....Error executing JavaScript: \(error)")
            } else {
                print("a4....Click simulated successfully.")
            }
        }
    }
    
    deinit {
        // Invalidate timer when the view controller is deallocated
        timerPoint?.invalidate()
        timerNext?.invalidate()
    }
    
    func stopAutoClicking() {
        selectBT.backgroundColor = UIColor.red
        timerPoint?.invalidate()
        timerPoint = nil // Clear the timer
        
        timerNext?.invalidate()
        timerNext = nil
        
       }
}

