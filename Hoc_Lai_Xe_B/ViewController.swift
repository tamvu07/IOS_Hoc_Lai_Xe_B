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

class ViewController: UIViewController {
    
    @IBOutlet weak var webView1: WKWebView!
    @IBOutlet weak var selectBT: UIButton!
    @IBOutlet weak var contentMainView: UIView!
    @IBOutlet weak var textNumberTF: UITextField!
    @IBOutlet weak var countDefaultLabel: UILabel!
    @IBOutlet weak var countSelectLabel: UILabel!
    
    var timerPoint: Timer?
    var clickIndicator: UIView!
    var arrayPoints: [PointObject] = [PointObject(x: 150, y: 150), PointObject(x: 150, y: 200), PointObject(x: 250, y: 0), PointObject(x: 150, y: 300), PointObject(x: 150, y: 350)]
    var timerNext: Timer?
    var timerPrevious: Timer?
    var isNext: Bool = true
    var countSelect: Int = 1
    var countDefaut: Int = 100
    //    var webView: WKWebView!
    
    @Published var isSelect: Bool = false
    
    var subscriptions = [AnyCancellable]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize WKWebView
        //        webView = WKWebView(frame: self.view.frame)
//        webView1.navigationDelegate = self
        //        self.view.addSubview(webView)
        
        contentMainView.isHidden = true
        
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
        
        showBtn()
        resetData()
    }
    
    @IBAction func btAction(_ sender: Any) {
        isSelect.toggle()
    }
    
    @IBAction func hiddenAction(_ sender: Any) {
        contentMainView.isHidden = true
    }
    
    @IBAction func doneAction(_ sender: Any) {
        guard let value = Int(textNumberTF.text ?? "0"), !((textNumberTF.text?.isEmpty) == nil) else { return }
        countDefaut = value
        countDefaultLabel.text = "\(countDefaut)"
        textNumberTF.resignFirstResponder()
        textNumberTF.text = ""
    }
    
    @IBAction func resetAction(_ sender: Any) {
        resetData()
    }
    
    
    @IBAction func goAction(_ sender: Any) {
        gotoNewVC()
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Start the timer to click the element every 2 seconds
        //        startAutoClicking()
    }
    
    func createClickIndicator() {
        clickIndicator = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        clickIndicator.backgroundColor = UIColor.clear
        clickIndicator.layer.cornerRadius = 10
        self.view.addSubview(clickIndicator)
    }
    
    func startAutoClicking() {
        stopAutoClicking()
        selectBT.backgroundColor = UIColor.green
        timerPoint = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(autoClick), userInfo: nil, repeats: true)
        
        if isNext {
            timerNext = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(autoNext), userInfo: nil, repeats: true)
        } else {
            timerPrevious = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(autoPrevious), userInfo: nil, repeats: true)
        }
    }
    
    @objc func autoClick() {
        for item in arrayPoints {
            numberPointSelect(x: item.x, y: item.y)
        }
    }
    
    @objc func autoNext() {
        nextAction(x: 340)
        countSelect += 1
        countSelectLabel.text = "\(countSelect)"
        if countSelect == countDefaut {
            isSelect.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
                self.countSelect = self.countDefaut
                self.isNext = false
                self.isSelect.toggle()
            })
        }
    }
    
    @objc func autoPrevious() {
        nextAction(x: 25)
        countSelect -= 1
        countSelectLabel.text = "\(countSelect)"
        if countSelect == 1 {
            isSelect.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
                self.countSelect = 1
                self.isNext = true
                self.isSelect.toggle()
            })
        }
    }
    
    func numberPointSelect(x: Int, y: Int) {
        
        let js = "var evt = new MouseEvent('click', {clientX: \(x), clientY: \(y), bubbles: true}); document.elementFromPoint(\(x), \(y)).dispatchEvent(evt);"
        
        webView1.evaluateJavaScript(js) { (result, error) in
            if let error = error {
                print("a3....Error number PointSelect: \(error)")
            } else {
                print("a3....number PointSelect Click.")
            }
        }
    }
    
    func nextAction(x: Int) {
//        var x = 340
        var y = 640
        
        clickIndicator.center = CGPoint(x: x, y: y)
        clickIndicator.backgroundColor = UIColor.green
        
        let js = "var evt = new MouseEvent('click', {clientX: \(x), clientY: \(y), bubbles: true}); document.elementFromPoint(\(x), \(y)).dispatchEvent(evt);"
        
        webView1.evaluateJavaScript(js) { (result, error) in
            if let error = error {
                print("a4....Error executing JavaScript: \(error)")
            } else {
                print("a4....Click simulated successfully........x is:\(x).......countSelect is:\(self.countSelect)......")
            }
        }
    }
    
    deinit {
        // Invalidate timer when the view controller is deallocated
        timerPoint?.invalidate()
        timerNext?.invalidate()
        timerPrevious?.invalidate()
    }
    
    func stopAutoClicking() {
        selectBT.backgroundColor = UIColor.red
        timerPoint?.invalidate()
        timerPoint = nil // Clear the timer
        
        timerNext?.invalidate()
        timerNext = nil
        
        timerPrevious?.invalidate()
        timerPrevious = nil
        
       }
    
     func showBtn() {
            DispatchQueue.main.async {
                let assistiveTouch = AssistiveTouch(frame: CGRect(x: self.view.bounds.width - 66, y: 180, width: 56, height: 56))
                assistiveTouch.addTarget(self, action: #selector(self.goToView(sender:)), for: .touchUpInside)
                assistiveTouch.setImage(UIImage(named: "ic_smartwatch_temp"), for: .normal)
                assistiveTouch.slectedAction = {
                    
                }
                assistiveTouch.tag = 69240
                self.view.addSubview(assistiveTouch)
            }
        }
    
    @objc func goToView(sender: UIButton) {
        contentMainView.isHidden = false
    }
    
    func gotoNewVC()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let destination = storyboard.instantiateViewController(withIdentifier: "ViewController1") as! ViewController1
        let nav = UINavigationController(rootViewController: destination)
        nav.setNavigationBarHidden(true, animated: true)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
    
    func resetData() {
        isSelect = false
        stopAutoClicking()
        textNumberTF.text = ""
        isNext = true
        countSelect = 1
        countDefaut = 100
        countDefaultLabel.text = "\(countDefaut)"
        countSelectLabel.text = "\(countSelect)"
        clickIndicator.backgroundColor = UIColor.clear
    }
}

