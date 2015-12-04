//
//  BookDetailController.swift
//  ItEbook
//
//  Created by 高永效 on 15/11/1.
//  Copyright © 2015年 高永效. All rights reserved.
//

import UIKit

class BookDetailController: UIViewController {
    
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var bookCover: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var pagesLabel: UILabel!
    @IBOutlet weak var publishDateLabel: UILabel!
    @IBOutlet weak var punlisherLabel: UILabel!
    @IBOutlet weak var briefTextView: UITextView!
    
    let baseURL = "http://it-ebooks-api.info/v1/book/"
    
    var bookID = ""
    
    let request = HTTPTask()
    
    var bookDetails: BookDetails!
    
    var eBook: EBook!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookCover.layer.cornerRadius = 10
        bookCover.clipsToBounds = true

        if bookID != "" {
            getBookDetails()
        }
        else {
            fillDetailsFromLocal()
            addButton.enabled = false
        }
    }
    
    //MARK: 获取书籍详细信息
    func getBookDetails() {
        let bookURL = baseURL + bookID
        request.GET(bookURL, parameters: nil) { (response: HTTPResponse) -> Void in
            if response.responseObject != nil {
                do {
                    let result = try NSJSONSerialization.JSONObjectWithData(response.responseObject as! NSData, options: NSJSONReadingOptions.MutableContainers) as! Dictionary<String, AnyObject>
                    self.bookDetails = BookDetails(dict: result)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.fillDetailsFromRemote()
                    })

                }
                catch {
                    self.showAlert("Failure", message: "Could Not Load The Book Details!")
                }
            }
            else {
                self.showAlert("Error", message: "Please Check Your Network!")
            }
        }
    }
    
    //MARK: 从服务器加载数据
    func fillDetailsFromRemote() {
        bookCover.sd_setImageWithURL(NSURL(string: bookDetails.imageURL), placeholderImage: UIImage(named: "openstack_swift"))
        titleLabel.text = bookDetails.title
        authorLabel.text = "Author: " + bookDetails.author
        pagesLabel.text = "Pages: " + bookDetails.pages
        publishDateLabel.text = "Year: " + bookDetails.publishDate
        punlisherLabel.text = bookDetails.publisher
        briefTextView.text = bookDetails.brief
    }
    
    //MARK: 从本地加载数据
    func fillDetailsFromLocal() {
        
        bookCover.image = UIImage(data: eBook.bookCover!)
        titleLabel.text = eBook.title
        authorLabel.text = "Author: " + eBook.author!
        pagesLabel.text = "Pages: " + eBook.pages!
        publishDateLabel.text = "Year: " + eBook.publishDate!
        punlisherLabel.text = eBook.publisher
        briefTextView.text = eBook.brief

    }
    
    //MARK: 添加收藏
    @IBAction func collectBook(sender: AnyObject) {
        
        //查看数据库里面是否有记录, 有的话直接返回
        let result = EBook.findByAttribute("isbn", withValue: bookDetails.isbn)
        print(result.count)
        if result.count != 0 {
            return
        }
        
        let book = EBook.MR_createEntity()
        book.bookCover = UIImageJPEGRepresentation(bookCover.image!, 1.0)
        book.title = bookDetails.title
        book.subTitle = bookDetails.subTitle
        book.author = bookDetails.author
        book.pages = bookDetails.pages
        book.publishDate = bookDetails.publishDate
        book.publisher = bookDetails.publisher
        book.brief = bookDetails.brief
        book.isbn = bookDetails.isbn
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        
        NSNotificationCenter.defaultCenter().postNotificationName("collectABook", object: nil)
    }
    
    func showAlert(title: String, message: String) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let alertView = NSBundle.mainBundle().loadNibNamed("SimpleAlertView", owner: nil, options: nil).first as! SimpleAlertView
            alertView.center.y = alertView.center.y + CGFloat(64)
            alertView.titleLabel.text = title
            alertView.messageLabel.text = message
            self.tabBarController!.tabBar.hidden = true
            alertView.setActionHandler({ () -> Void in
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    alertView.layer.opacity = 0
                    alertView.center.y = UIScreen.mainScreen().bounds.height
                    }, completion: { (_) -> Void in
                        alertView.removeFromSuperview()
                        self.tabBarController!.tabBar.hidden = false
                })
            })
            self.view.addSubview(alertView)
        })
    }

}
