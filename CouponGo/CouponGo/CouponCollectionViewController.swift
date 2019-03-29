//
//  couponCollectionViewController.swift
//  CouponGo
//
//  Created by Ava on 3/16/19.
//  Copyright © 2019 CouponGo. All rights reserved.
//

import UIKit

private let reuseIdentifier = "coupon_cell"

class CouponCollectionViewController: UICollectionViewController {
    
    let localStorage = UserDefaults.standard
    var userCollection = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // a list of coupon objects, each of which has already been hashed into a string
        // containing all the relevant info about this coupon
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.userCollection = localStorage.object(forKey: "myCouponList") as! [String]
        self.collectionView.reloadData()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userCollection.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CouponCollectionViewCell
        
        let curCoupon = userCollection[indexPath.row]
        let curCouponInfo = curCoupon.split(separator: "*")
        
        print("c\(curCouponInfo[4])")
        cell.couponImage.image = UIImage(named: "c\(curCouponInfo[4])")
        cell.couponName.text = String(curCouponInfo[0])
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if(segue.identifier == "couponSegue"){
            let Detail = segue.destination as! CouponDetailViewController
            let cell = sender
            let indexPath = self.collectionView?.indexPath(for: cell as! UICollectionViewCell)
            let curCoupon = userCollection[indexPath!.row]

            let curCouponInfo = curCoupon.split(separator: "*")
//            Detail.couponCodeText = curCoupon.businessName
            Detail.couponCodeText = String(curCouponInfo[1])
//            Detail.couponUsageText = String(curCouponInfo)
            Detail.resNameText = String(curCouponInfo[0])

            // get the expire month
            
//            var Expire = String(curCouponInfo[3])
//            Expire = String(Expire.prefix(10))
//            let start = Expire.index(Expire.startIndex, offsetBy: 5)
//            let end = Expire.index(Expire.endIndex, offsetBy: 7)
//            let range = start..<end
//            let tmp = String(Expire[range])
//            let month:Int? = Int(tmp)
            

            // replace substring of Expire
//            var char = Array(Expire)
//            if month!+2 <= 10{
//                char[5] = "0"
//                char[6] = Character(UnicodeScalar(month!+2)!)
//            }else{
//                char[5] = "1"
//                char[6] = Character(UnicodeScalar(month!+2-10)!)
//            }
            let expireDate = curCouponInfo[3].prefix(10)
            Detail.expireDateText = String(expireDate)
            
            let UsageString: [String] = ["Get 20% off!","Buy one get one free!","$15 off $100!"]
            Detail.couponType = Int(Int(curCouponInfo[4])!-1)
            Detail.couponUsageText = UsageString[Detail.couponType!]
            Detail.couponIndex = indexPath!.row
            
            //curCouponInfo [ businessName, ID/code, * ,date 2019-03-20 04:05:31]
            
//            Detail.couponCodeText = coupon.
            
//            Detail.couponCodeText = cell.couponName
            
        }
    }
    

    
}
