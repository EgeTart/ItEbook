//
//  BookCoverCell.swift
//  ItEbook
//
//  Created by 高永效 on 15/11/1.
//  Copyright © 2015年 高永效. All rights reserved.
//

import UIKit

class BookCoverCell: UICollectionViewCell {
    
    
    @IBOutlet weak var deleteIcon: UIImageView!
    @IBOutlet weak var bookCover: UIImageView!
    
    override func awakeFromNib() {
        bookCover.layer.cornerRadius = 10
        bookCover.clipsToBounds = true
    }
    
}
