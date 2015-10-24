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
    var totalPage = 0
    
    var sectionTitles = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchButton = barItem
        
        setupSearchBar()
        
        tableView.tableFooterView = UIView()
        tableView.tableFooterView?.tag = 105
        
        sectionTitles.append("Page 1")
        tableView.footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: "loadMoreBooks")
        
    }
    
    func setupBackgroundView() {
        
        backgroundView.frame = self.view.frame
        
        backgroundView.backgroundColor = UIColor.whiteColor()
        backgroundView.layer.opacity = 1.0
        
        let imageView = UIImageView(frame: self.tableView.frame)
        imageView.frame.size = CGSize(width: self.view.frame.width, height: self.tableView.frame.height - 108)
        imageView.image = UIImage(named: "bg1")
        backgroundView.addSubview(imageView)
        
        self.view.addSubview(backgroundView)
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
        currentPage++
        
        self.sectionTitles.append("Page \(currentPage)")
        
        self.searchBooks()
    
    }
    
// MARK: - Search books
    func searchBooks() {
    
        let searchUrl = baseUrl + searchBar.text! + "/page/" + "\(currentPage)"
        
        searchRequest.GET(searchUrl, parameters: nil) { (response: HTTPResponse) -> Void in
            
            if response.responseObject != nil {
                
                let results = try! NSJSONSerialization.JSONObjectWithData(response.responseObject as! NSData, options: NSJSONReadingOptions.MutableContainers) as! Dictionary<String, AnyObject>
                
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
    
        let cell = tableView.dequeueReusableCellWithIdentifier("bookCell", forIndexPath: indexPath)
        
        let onePageBooks = books[indexPath.section]
        
        cell.imageView!.sd_setImageWithURL(NSURL(string: onePageBooks[indexPath.row].image), placeholderImage: UIImage(named: "openstack_swift"))
        cell.imageView?.layer.cornerRadius = 8
        cell.imageView?.clipsToBounds = true
        
        let itemSize = CGSize(width: 90, height: 104)
        UIGraphicsBeginImageContext(itemSize)
        cell.imageView!.image?.drawInRect(CGRect(x: 0, y: 0, width: itemSize.width, height: itemSize.height))
        cell.imageView!.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        cell.textLabel!.text = onePageBooks[indexPath.row].title
        
        if onePageBooks[indexPath.row].subTitle != "" {
            cell.detailTextLabel!.text = onePageBooks[indexPath.row].subTitle
        }
        else {
            cell.detailTextLabel!.hidden = true
        }
    
        return cell
    }
    
}

// MARK: - Table view delegate
extension BookListController {

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        
        let itemSize = CGSize(width: 90, height: 104)
        UIGraphicsBeginImageContext(itemSize)
        cell.imageView!.image?.drawInRect(CGRect(x: 0, y: 0, width: itemSize.width, height: itemSize.height))
        cell.imageView!.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 120
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
}

// MARK: - UISearchBar delegate
extension BookListController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchBar.hidden = true
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        self.navigationItem.rightBarButtonItem = searchButton
        
        self.title = self.titleString
        
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        
        searchBar.showsCancelButton = true
        searchBar.text = ""
        self.title = searchBar.text!
        return true
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        self.books = []
        
        self.searchBooks()
        
        self.searchBar.hidden = true
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        self.navigationItem.rightBarButtonItem = searchButton
        
        self.title = searchBar.text!
        self.titleString = searchBar.text!
    }
    
}
