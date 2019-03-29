//
//  CustomMarker.swift
//  CouponGo
//
//  Created by Tieyong Yu on 3/16/19.
//  Copyright © 2019 CouponGo. All rights reserved.
//

import UIKit

// CustomMarker for restaurant
class CustomMarker: UIView {
    
    var image: UIImage!
    var borderColor: UIColor!
    var restaurantName: String!
    var rating: String?
    var url: String!
    
    
    init(frame: CGRect, image: UIImage, borderColor: UIColor, restaurantName: String, rating: String, url: String) {
        super.init(frame: frame)
        self.image = image
        self.borderColor = borderColor
        self.restaurantName = restaurantName
        self.rating = rating
        self.url = url
        addViewComponents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addViewComponents() {
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        imageView.layer.cornerRadius = 25
        imageView.layer.borderColor = borderColor?.cgColor
        imageView.layer.borderWidth = 4
        imageView.clipsToBounds = true
        // add the imageView as subview
        self.addSubview(imageView)
    }
    
    func updateBorderColor(color: UIColor) {
        self.borderColor = color
        self.subviews[0].layer.borderColor = self.borderColor.cgColor
    }
    
    

}
