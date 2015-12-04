//
//  BookDetails.swift
//  ItEbook
//
//  Created by 高永效 on 15/11/1.
//  Copyright © 2015年 高永效. All rights reserved.
//

class BookDetails {
    
//    Author = "Dr Alex Blewitt";
//    Description = "Swift is a new and powerful programming language that represents an essential new programming tool for iOS and OSX applications and builds upon the power of Objective-C while streamlining the developer experience.\n\nSwift Essentials is a fast-paced, practical guide showing you the quickest way to put Swift to work in the real world. It guides you concisely through the basics of syntax and development before pushing ahead to explore Swift's higher features through practical programming projects.\n\nBy the end of the book, you will be able to use Xcode's graphical interface builder, create interactive applications, and communicate with network services.";
//    Download = "http://filepi.com/i/U1I82Yp";
//    Error = 0;
//    ID = 2241584224;
//    ISBN = 9781784396701;
//    Image = "http://s.it-ebooks-api.info/14/swift_essentials.jpg";
//    Page = 228;
//    Publisher = "Packt Publishing";
//    SubTitle = "Get up and running lightning fast with this practical guide to building applications with Swift";
//    Time = "0.00141";
//    Title = "Swift Essentials";
//    Year = 2014;
    
    var author: String
    var brief: String
    var imageURL: String
    var pages: String
    var title: String
    var subTitle: String
    var publishDate: String
    var publisher: String
    var isbn: String


    init(dict: Dictionary<String, AnyObject>) {
        
        author = dict["Author"] as! String
        brief = dict["Description"] as! String
        imageURL = dict["Image"] as! String
        pages = dict["Page"] as! String
        title = dict["Title"] as! String
        
        if dict.keys.contains("SubTitle") {
            subTitle = dict["SubTitle"] as! String
        }
        else {
            subTitle = ""
        }
        
        publishDate = dict["Year"]!.description
        publisher = dict["Publisher"] as! String
        isbn = dict["ISBN"] as! String
    }
    
}
