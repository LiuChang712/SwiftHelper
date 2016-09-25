//
//  LCKeyboardManager.swift
//  SwiftHelper
//
//  Created by 刘畅 on 16/7/18.
//  Copyright © 2016年 LiuChang. All rights reserved.
//

import UIKit

public class KeyboardManager: NSObject {
    /// 距离底部的间隔，默认为10
    public var bottomInterval: CGFloat = 10
    
    private var frame: CGRect!
    private var changeView: UIView!
    
    public static let shareInstance: KeyboardManager = KeyboardManager()
    
    /**
     添加监听键盘
     
     - parameter rect: 需要监听视图的frame
     - parameter view: 要改变frame的视图
     */
    public func addObserverInView(view: UIView, objectRect rect: CGRect) {
        removeObserver()
        addKeyboardObserver()
        self.frame = rect
        self.changeView = view
    }
    
    /**
     删除
     */
    public func removeObserver() {
        let center = NSNotificationCenter.defaultCenter()
        center.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        center.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

}

private extension KeyboardManager {
    
   func addKeyboardObserver() {
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(note:NSNotification){
        let telMaxY = CGRectGetMaxY(frame)
        let keyboardH : CGFloat = (note.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size.height)!
        let keyboardY : CGFloat = changeView.frame.size.height - keyboardH
        var duration  = note.userInfo![UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        if duration < 0.0 {
            duration = 0.25
        }
        UIView.animateWithDuration(duration!) { () -> Void in
            if (telMaxY > keyboardY) {
                self.changeView.transform = CGAffineTransformMakeTranslation(0, keyboardY - telMaxY - self.bottomInterval)
            }else{
                self.changeView.transform = CGAffineTransformIdentity
            }
        }
        
    }
    
    @objc func keyboardWillHide(note:NSNotification){
        let duration  = note.userInfo![UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        UIView.animateWithDuration(duration!) { () -> Void in
            self.changeView.transform = CGAffineTransformIdentity
        }
    }
    
}
