//
//  Book.swift
//  ItEbook
//
//  Created by 高永效 on 15/9/17.
//  Copyright © 2015年 高永效. All rights reserved.
//

import Foundation
import UIKit

class Book {
    
//    Description = "Swift Quick Syntax Reference is a condensed code and syntax reference to the new Apple Swift programming language, which is the alternative new programming language alongside Objective-C behind the APIs found in the Apple iOS SDK 8 and OS X Yosemite ...";
//    ID = 2707577964;
//    Image = "http://s.it-ebooks-api.info/6/swift_quick_syntax_reference.jpg";
//    Title = "Swift Quick Syntax Reference";
//    isbn = 9781484204405;
    
    var description = ""
    var bookID = ""
    var image = ""
    var title = ""
    var subTitle = ""
    
    init(dict: Dictionary<String, AnyObject>) {
        
        self.description = dict["Description"] as! String
        self.bookID = dict["ID"]!.description
        self.image = dict["Image"] as! String
        self.title = dict["Title"] as! String
        
        if dict.keys.contains("SubTitle") {
            self.subTitle = dict["SubTitle"] as! String
        }

    }
    
}

class Books {
    
    var books = [Book]()
    
    init(bookArray: Array<Dictionary<String, AnyObject>>) {
        
        for item in bookArray {
            let book = Book(dict: item)
            books.append(book)
        }
    }
    
    func getBooks() -> [Book]{
        return books
    }
    
}
