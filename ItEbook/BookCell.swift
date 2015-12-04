//
//  BookCell.swift
//  ItEbook
//
//  Created by 高永效 on 15/11/1.
//  Copyright © 2015年 高永效. All rights reserved.
//

import UIKit

class BookCell: UITableViewCell {
    
    
    @IBOutlet weak var bookCover: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bookCover.layer.cornerRadius = 10
        bookCover.clipsToBounds = true
    }

}
