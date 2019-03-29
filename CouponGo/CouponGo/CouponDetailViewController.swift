//
//  CouponDetailViewController.swift
//  CouponGoCouponCollectionViewCell
//
//  Created by Ava on 3/19/19.
//  Copyright © 2019 CouponGo. All rights reserved.
//

import UIKit

class CouponDetailViewController: UIViewController {

    @IBOutlet weak var couponCode: UILabel!
    @IBOutlet weak var resName: UILabel!
    @IBOutlet weak var couponUsage: UILabel!
    @IBOutlet weak var expireDate: UILabel!
    
    @IBOutlet weak var useCodeButton: UIButton!
    var couponCodeText: String?
    var resNameText: String?
    var couponUsageText: String?
    var expireDateText: String?
    var couponType: Int?
    var couponIndex: Int?
    
    let localStorage = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        useCodeButton.isEnabled = true
        print("come in")
        // couponCode: promotion Code
//        couponCode.text = couponCodeText
//        couponCode.lineBreakMode = NSLineBreakMode.byWordWrapping
        // resName: restaurant name
        resName.text = resNameText!
        resName.numberOfLines = 0
        resName.lineBreakMode = NSLineBreakMode.byWordWrapping
        // couponUsage: way of sales
        couponUsage.text = couponUsageText!
        // expireDate: expire date for this coupon
        expireDate.text = expireDateText!
        
        // set different background color for couponDetailView
//        var color = setBackgroundColor(type: couponIndex!)
        self.view.backgroundColor = UIColor.yellow
            //UIColor(red: color[0], green: color[1], blue: color[2], alpha: 1)
        
        // btn tapped
        useCodeButton.addTarget(self, action: #selector(useCodeButtonTapped), for: .touchUpInside)
    }
    @objc func useCodeButtonTapped(_ sender: Any) {
        couponCode.text = randomString(length: 5)
        couponCode.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        var userCouponCollection: [String] = localStorage.object(forKey: "myCouponList") as! [String]
        userCouponCollection.remove(at: couponIndex!)
        localStorage.set(userCouponCollection, forKey: "myCouponList")
        useCodeButton.isEnabled = false
    }
    // generate random string
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    // return corresponding backgound color
    func setBackgroundColor (type: Int)->[CGFloat]{
        var color = [CGFloat]()
        color.append(0)
        color.append(0)
        color.append(0)
        if type == 0{
            color[0] = 255
            color[1] = 120
            color[2] = 120
        }
        if type == 1{
            color[0] = 0
            color[1] = 180
            color[2] = 150
        }
        if type == 2{
            color[0] = 50
            color[1] = 150
            color[2] = 200
        }
        return color
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
