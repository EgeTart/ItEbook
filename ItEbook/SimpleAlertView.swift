//
//  SimpleAlertView.swift
//  SimpleAlertView
//
//  Created by 高永效 on 15/10/29.
//  Copyright © 2015年 EgeTart. All rights reserved.
//

import UIKit

@objc protocol SimpleAlertViewDelegate {
    optional func simpleAlertView(actionType: String)
}

class SimpleAlertView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    private var confirmHandler: (() -> Void)?
    
    var delegate: SimpleAlertViewDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //view的位置和大小
        self.frame.size = CGSize(width: 280.0, height: 130.0)
        self.center = CGPoint(x: UIScreen.mainScreen().bounds.midX, y: -self.frame.size.height)
        
        //view的阴影
        self.layer.shadowColor = UIColor(white: 0, alpha: 1).CGColor
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowOpacity = 0.5
        
        //view的边框
        self.layer.borderWidth = 0.3
        self.layer.borderColor = UIColor(white: 0, alpha: 0.5).CGColor
        
        //设置按钮的圆角
        confirmButton.layer.cornerRadius = 5
        confirmButton.clipsToBounds = true
        
        //把view的透明度设为0, 逆时针旋转45度
        self.layer.opacity = 0
        self.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_4))
        
        //持续0.3秒的动画, 实现渐变效果和旋转效果
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.center = CGPoint(x: UIScreen.mainScreen().bounds.midX, y: UIScreen.mainScreen().bounds.midY - 64.0)
            self.layer.opacity = 1
            self.transform = CGAffineTransformMakeRotation(CGFloat(0))
            }, completion: nil)
    }
    
    func setActionHandler(handler: () -> Void) {
        
            confirmHandler = handler
    }
    
    @IBAction func confirm(sender: UIButton) {
    
        self.confirmHandler!()
       
        
    }
    
}
