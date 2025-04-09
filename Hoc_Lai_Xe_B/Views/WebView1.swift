//
//  WebView1.swift
//  Hoc_Lai_Xe_B
//
//  Created by Tam Vu on 09/04/2025.

import UIKit
import WebKit

class WebView1: UIView {

    @IBOutlet weak var webView1: WKWebView!
    
    var contentView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        setUpUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        setUpUI()
    }
    
    
    func xibSetup() {
        
        contentView = loadViewFromNib()

        // use bounds not frame or it'll be offset
        contentView!.frame = bounds

        // Make the view stretch with containing view
        contentView!.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        if #available(iOS 13.0, *) {
           
        } else {
            self.contentView?.backgroundColor = .white
        }
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(contentView!)
    }

    func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return UIView() }
        return view
    }
    
    func setUpUI() {
//        webView1.navigationDelegate = self
        if let url = URL(string: "https://tuanlong.huelms.com/user/login/?logout=1") {
            let request = URLRequest(url: url)
            webView1.load(request)
        }
    }
    
}


