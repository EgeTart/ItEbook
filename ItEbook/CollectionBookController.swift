//
//  CollectionBookController.swift
//  ItEbook
//
//  Created by 高永效 on 15/11/1.
//  Copyright © 2015年 高永效. All rights reserved.
//

import UIKit

class CollectionBookController: UIViewController {

    @IBOutlet weak var bookCollectionView: UICollectionView!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var books = [EBook]()
    
    var editModel = false
    
    var deleleIcons = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        books = EBook.findAll() as! [EBook]

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reload:", name: "collectABook", object: nil)

    }
    
    func reload(notification: NSNotification) {
        books = EBook.findAll() as! [EBook]
        bookCollectionView.insertItemsAtIndexPaths([NSIndexPath(forItem: books.count - 1, inSection: 0)])
        
    }
    
    @IBAction func editCollection(sender: AnyObject) {
        editModel = true
        bookCollectionView.reloadData()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "completed")
    }
    
    func completed() {
        navigationItem.rightBarButtonItem = nil
        editModel = false
        bookCollectionView.reloadData()
    }

}

extension CollectionBookController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("bookCell", forIndexPath: indexPath) as! BookCoverCell
        cell.bookCover.image = UIImage(data: books[indexPath.item].bookCover!)
        
        if editModel == true {
            cell.deleteIcon.image = UIImage(named: "delete")
        }
        else {
            cell.deleteIcon.image = UIImage()
        }
        
        return cell
    }

}

extension CollectionBookController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //非编辑状态则跳转
        if editModel == false {
            self.performSegueWithIdentifier("bookDetails", sender: self)
        }
        else {
            let book = books[indexPath.item]
            book.MR_deleteEntity()
            NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
            books.removeAtIndex(indexPath.item)
            collectionView.deleteItemsAtIndexPaths([indexPath])
            
        }
    }
    
    //为跳转做准备, 传递本地数据
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = bookCollectionView.indexPathsForSelectedItems()!.first!
        let destinationVC = segue.destinationViewController as! BookDetailController
        destinationVC.eBook = books[indexPath.item]
    }

}

//MARK: 控制collectionView的布局

extension CollectionBookController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = (self.view.frame.width - 50.0) / 2.0
        return CGSize(width: width, height: width * CGFloat(1.3))
    }
}
