//
//  CouponMarker.swift
//  CouponGo
//
//  Created by Tieyong Yu on 3/18/19.
//  Copyright © 2019 CouponGo. All rights reserved.
//

import UIKit

// CustomMarker for coupons
class CouponMarker: UIView {

    var image: UIImage!
    var borderColor: UIColor!
    var couponName: String! // coupon's name (including restaurant it's attached to)
    var functionality: String! // short description of its functionality
    var coupon: Coupon!
    
    
    init(frame: CGRect, image: UIImage, borderColor: UIColor, couponName: String, functionality: String, coupon: Coupon) {
        super.init(frame: frame)
        self.image = image
        self.borderColor = borderColor
        self.couponName = couponName
        self.functionality = functionality
        self.coupon = coupon
        addViewComponents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addViewComponents() {
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
//        imageView.layer.cornerRadius = 25
        imageView.layer.borderColor = borderColor?.cgColor
        imageView.layer.borderWidth = 2
        imageView.clipsToBounds = true
        // add the imageView as subview
        self.addSubview(imageView)
    }
    
    func updateBorderColor(color: UIColor) {
        self.borderColor = color
        self.subviews[0].layer.borderColor = self.borderColor.cgColor
    }

}
