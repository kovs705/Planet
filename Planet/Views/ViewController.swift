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
import RealmSwift

class ViewController: UIViewController, WKNavigationDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var webView: UIView!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    var currentWebView: WKWebView!
    var errorView = UIView()
    var errorLabel = UILabel()
    
    var bookmarks = [Bookmark]()
    var tabs = [Tab]()
    var webViews = [WKWebView]()
    
    var selectedTab: Int!
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadBookmarks()
        loadTabs()
        
        configureSearchBar()
        configureWebViewError()
        
        loadWebView()
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // MARK: - Configuration functions:
    func configureSearchBar() {
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
    }
    
    func configureWebView() -> WKWebView {
        let webConfig = WKWebViewConfiguration()
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: webView.frame.height)
        
        let webView = WKWebView(frame: frame, configuration: webConfig)
        webView.navigationDelegate = self
        return webView
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
    
    // MARK: - Load functions
    func loadTabs() {
        let realm = try! Realm()
        let results = realm.objects(Tab.self)
        
        for result in results {
            webViews.append(configureWebView())
            tabs.append(result)
        }
        
        selectedTab = 0
    }
    
    func addTab(_ tab: Tab) {
        tabs.append(tab)
        if selectedTab != 0 {
            selectedTab = tabs.count - 1
        } else {
            selectedTab = 0
        }
        webViews.append(configureWebView())
        loadWebView()
    }
    
    func loadWebView() {
        currentWebView?.removeFromSuperview()
        currentWebView = webViews[selectedTab]
        webView.addSubview(currentWebView)
        
        if currentWebView.url == nil && !tabs[selectedTab].url.isEmpty {
            loadWebsite(tabs[selectedTab].url, true, true)
        } else {
            searchBar.text = currentWebView.url?.absoluteString
        }
        updateNavigationToolbarButtons()
    }
    
    func loadBookmarks() {
        let realm = try! Realm()
        let results = realm.objects(Bookmark.self)
        
        bookmarks.removeAll()
        
        for result in results {
            bookmarks.append(result)
        }
    }
    
    // MARK: - WKWebView functions:
    func loadWebsite(_ input: String, _ isUrlDomain: Bool, _ isURLPreprocessed: Bool) {
        var encodedURL: String = input
        
        if !isURLPreprocessed {
            if (isUrlDomain) {
                if encodedURL.starts(with: "http://") {
                    encodedURL = String(encodedURL.dropFirst(7))  // "deletes" this http://
                }
                else if encodedURL.starts(with: "https://") {
                    encodedURL = String(encodedURL.dropFirst(8))
                }
                
                encodedURL = "https://" + encodedURL.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                
            } else {
                encodedURL = "https://www.google.com/search?dcr=0&q=" + encodedURL.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            }
        }
        
        // actual URL request
        let url: URL = URL(string: "\(encodedURL)")!
        let urlRequest: URLRequest = URLRequest(url: url)
        
        // load request:
        currentWebView.load(urlRequest)
        hideWebViewError()
        searchBar.text = encodedURL.lowercased()
        
        let tab: Tab = tabs[selectedTab]
        let realm = try! Realm()
        try! realm.write {
            tab.initialURL = encodedURL.lowercased()
        }
    }
    
    // MARK: - WebView errors
    
    func displayWebViewError(_ error: String) {
        errorLabel.text = error
        webView.addSubview(errorView)
        webView.addSubview(errorLabel)
    }
    
    func hideWebViewError() {
        errorView.removeFromSuperview()
        errorLabel.removeFromSuperview()
    }
    
    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("Commited")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // last part of loading the request:
        print("Finished")
        updateNavigationToolbarButtons()
        
        let tab = tabs[selectedTab]
        let realm = try! Realm()
        try! realm.write {
            tab.title = currentWebView.title!
            tab.url = (currentWebView.url?.absoluteString)!
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // calls when the LOADING process BEGINS
        print("Startet provisional navigation func")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        displayWebViewError(error.localizedDescription)
        updateNavigationToolbarButtons()
    }
    
//    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
//        completionHandler(.useCredential, cred)
//    }
    
    // MARK: UISearchBar delegate
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        if let url = currentWebView.url?.absoluteString {
            let realm = try! Realm()
            let newBookmark = Bookmark(value: ["url": url, "title": currentWebView.title])
            
            try! realm.write {
                realm.add(newBookmark, update: .modified)
                print("added new bookmark")
            }
            
            loadBookmarks()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // hides keyboard
        
        let input: String = (searchBar.text?.trimmingCharacters(in: .whitespaces))!
        if (!input.isEmpty) { // if input of the searchBar isn't empty
            if input.hasSuffix(".com") || input.hasSuffix(".com/") || input.hasSuffix(".tv") || input.hasSuffix(".tv/") {
                // if input has some of these suffixes:
                loadWebsite(input, true, false)
            } else {
                loadWebsite(input, false, false)
            }
        }
    }
    
    
    // MARK: - Toolbar functions and buttons
    func updateNavigationToolbarButtons() {
        // this function updates the toolbar and its buttons, depending on web pages and where is the user:
        
        // forward:
        if currentWebView.canGoForward {
            forwardButton.isEnabled = true
        } else {
            forwardButton.isEnabled = false
        }
        
        // back:
        if currentWebView.canGoBack {
            backButton.isEnabled = true
        } else {
            backButton.isEnabled = false
        }
    }
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        if errorView.isDescendant(of: webView) {
            hideWebViewError()
        } else {
            currentWebView.goBack()
        }
        searchBar.text = currentWebView.url?.absoluteString
    }
    
    @IBAction func goForward(_ sender: UIBarButtonItem) {
        currentWebView.goForward()
        hideWebViewError()
        searchBar.text = currentWebView.url?.absoluteString
    }
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        currentWebView.reload()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Tabs" {
            let tabsVC = segue.destination as! TabsTBC
            tabsVC.tabs = self.tabs
            tabsVC.delegate = self
            tabsVC.selectedTab = selectedTab
        } else { // "Booksmarks"
            let bookmarksVC = segue.destination as! BookmarksTBC
            bookmarksVC.bookmarks = self.bookmarks
        }
    }

}

