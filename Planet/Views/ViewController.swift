//
//  ViewController.swift
//  Planet
//
//  Created by Kovs on 07.09.2022.
//

/// First of all, as you can see, the apps name is Planet. It will use Realm dependency with CocoaPods, XCTests
/// and other things that I will think about later (like sharing feature).
///

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var webView: UIView!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    var currentWebView: WKWebView!
    var errorView = UIView()
    var errorLabel = UILabel()
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchBar()
        configureWebView()
        configureWebViewError()
        
    }
    
    // MARK: - Configuration functions:
    func configureSearchBar() {
        searchBar.delegate = self
    }
    
    func configureWebView() {
        let webConfig = WKWebViewConfiguration()
        let frame = CGRect(x: 0, y: 0, width: webView.frame.width, height: webView.frame.height)
        
        currentWebView = WKWebView(frame: frame, configuration: webConfig)
        currentWebView.navigationDelegate = self
        webView.addSubview(currentWebView)
    }
    
    func configureWebViewError() {
        var frame = CGRect(x: 0, y: 0, width: webView.frame.width, height: webView.frame.height)
        errorView = UIView(frame: frame)
        errorView.backgroundColor = UIColor.white
        
        frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        errorLabel = UILabel(frame: frame)
        errorLabel.backgroundColor = UIColor.white
        errorLabel.textColor = UIColor.systemGray
        errorLabel.text = ""
        errorLabel.textAlignment = .center
        errorLabel.font = UIFont(name: "HelveticaNeue", size: 25)
        errorLabel.numberOfLines = 0
    }
    
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func goForward(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        
    }
    

}

