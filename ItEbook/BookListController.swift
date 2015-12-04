//
//  BookListController.swift
//  ItEbook
//
//  Created by 高永效 on 15/9/15.
//  Copyright © 2015年 高永效. All rights reserved.
//

import UIKit

class BookListController: UITableViewController {

    let searchRequest = HTTPTask()
    
    let baseUrl = "http://it-ebooks-api.info/v1/search/"
    
    var books = [[Book]]()
    
    let searchBar = UISearchBar()
    
    @IBOutlet weak var barItem: UIBarButtonItem!
    
    var searchButton = UIBarButtonItem()
    
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    let loadMoreButton = UIButton()
    
    let backgroundView = UIView()
    
    var titleString = ""
    
    var currentPage = 1
    var totalPages = 0
    
    var sectionTitles = [String]()
    
    let imageView = UIImageView(frame: CGRect(origin: CGPointZero, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height - 108)))
    
    var isSearch = false
    var lastSearch = ""
    var lastPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchButton = barItem
        
        setupSearchBar()
        
        tableView.tableFooterView = UIView()
        tableView.tableFooterView?.tag = 105
        
        sectionTitles.append("Page 1")
        tableView.footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: "loadMoreBooks")
        
        imageView.image = UIImage(named: "bg")
        self.view.addSubview(imageView)
        self.tableView.scrollEnabled = false
        
    }
    
// MARK: - Setup SearchBar
    @IBAction func showSearchBar() {
        
        self.backgroundView.hidden = true
        
        self.searchBar.hidden = false
        self.searchBar.becomeFirstResponder()
        
        self.navigationItem.rightBarButtonItem = nil
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
        self.searchBar.frame = CGRect(x: 20, y: 0, width: self.view.frame.width - 40, height: 44)
        //searchBar.showsCancelButton = true
        searchBar.searchBarStyle = UISearchBarStyle.Minimal
        self.navigationController?.navigationBar.addSubview(searchBar)
        searchBar.hidden = true
    }
    
    func loadMoreBooks() {

        if isSearch == true {
            currentPage = lastPage
        }
        
        currentPage++
        lastPage = currentPage

        sectionTitles = []
        for page in 1...currentPage {
            self.sectionTitles.append("Page \(page)")

        }
        
        if totalPages < 0 {
            tableView.footer.endRefreshingWithNoMoreData()
            return
        }
        totalPages -= 10

        self.searchBooks()
    
    }
    
// MARK: - Search books
    func searchBooks() {
        
        if self.view.subviews.contains(imageView) {
            imageView.removeFromSuperview()
            tableView.scrollEnabled = true
        }
        
        let searchUrl = baseUrl + searchBar.text! + "/page/" + "\(currentPage)"
        
        searchRequest.GET(searchUrl, parameters: nil) { (response: HTTPResponse) -> Void in
            
            if response.responseObject != nil {
                do {
                    
                    let results = try NSJSONSerialization.JSONObjectWithData(response.responseObject as! NSData, options: NSJSONReadingOptions.MutableContainers) as! Dictionary<String, AnyObject>
                    
                    let total = results["Total"] as! String
                    
                    if self.totalPages == 0 {
                        self.books = []
                        self.currentPage = 1
                        self.totalPages = Int(total, radix: 10)! - 10
                        self.lastSearch = self.searchBar.text!
                        self.isSearch = false
                       
                    }
                    
                    if self.isSearch == true && total != "0" {
                        self.books = []
                        self.currentPage = 1
                        self.totalPages = Int(total, radix: 10)! - 10
                        self.lastSearch = self.searchBar.text!
                        self.isSearch = false
                    }

                    if total == "0" {
    
                        self.showAlert("Error", message: "Please Check The Key Word You Enter!")
                        self.isSearch = false
                        self.searchBar.text = self.lastSearch
                        self.currentPage = self.lastPage
                    }
                    else {
                        
                        let bookResults = Books(bookArray: results["Books"] as! Array<Dictionary<String, AnyObject>>)
                        let onePageBooks = bookResults.getBooks()
                        self.books.append(onePageBooks)
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.tableView.footer.endRefreshing()
                            self.tableView.reloadData()
                            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: self.currentPage - 1), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
                            
                        })
                    }
                    
                }
                catch {
                   
                    self.showAlert("Error", message: "Please Check The Key Word You Enter!")
                }
                
            }
            else {
                self.showAlert("Error", message: "Please Check Your Network!")
            }
        }
    }
    
    func showAlert(title: String, message: String) {
       
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let alertView = NSBundle.mainBundle().loadNibNamed("SimpleAlertView", owner: nil, options: nil).first as! SimpleAlertView
            alertView.center.y = self.tableView.contentOffset.y + alertView.center.y + CGFloat(64)
            alertView.titleLabel.text = title
            alertView.messageLabel.text = message
            self.tabBarController!.tabBar.hidden = true
            
            alertView.setActionHandler({ () -> Void in
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    alertView.layer.opacity = 0
                    alertView.center.y = self.tableView.contentOffset.y + UIScreen.mainScreen().bounds.height
                    }, completion: { (_) -> Void in
                        alertView.removeFromSuperview()
                        self.tabBarController!.tabBar.hidden = false
                })
            })
            
            self.view.addSubview(alertView)
        })

    }
    
}

// MARK: - Table view data source
extension BookListController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return books.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return books[section].count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("bookCell", forIndexPath: indexPath) as! BookCell
        
        let onePageBooks = books[indexPath.section]
        
        cell.bookCover.sd_setImageWithURL(NSURL(string: onePageBooks[indexPath.row].image), placeholderImage: UIImage(named: "openstack_swift"))

        cell.titleLabel.text = onePageBooks[indexPath.row].title
        cell.subTitleLabel.hidden = true

        return cell
    }
    
}

// MARK: - Table view delegate
extension BookListController {
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 130
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("bookDetails", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let selectedIndex = tableView.indexPathForSelectedRow!
        let bookID = books[selectedIndex.section][selectedIndex.row].bookID
        
        let destinationVC = segue.destinationViewController as! BookDetailController
        destinationVC.bookID = bookID
    }
        
}

// MARK: - UISearchBar delegate
extension BookListController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchBar.hidden = true
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        self.navigationItem.rightBarButtonItem = searchButton
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor()]
        
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        
        searchBar.showsCancelButton = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.clearColor()]
        searchBar.text = ""
        return true
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        isSearch = true
        currentPage = 1
        self.searchBooks()
        
        self.searchBar.hidden = true
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        self.navigationItem.rightBarButtonItem = searchButton
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor()]

    }
    
}
