//
//  CameraViewController.swift
//  
//
//  Created by Ava on 3/18/19.
//

import UIKit
import AVFoundation
import ARKit
import SceneKit

class CameraViewController: UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    
    @IBOutlet var WholeView: UIView!
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var captureButton: UIButton!
//    @IBOutlet weak var couponGif: UIImageView!
    @IBOutlet weak var couponButton: UIButton!
    @IBOutlet weak var OKButton: UIButton!
    
    @IBOutlet weak var infoLabel2: UILabel!
    // field variables
    let configuration = ARWorldTrackingConfiguration()
    let CouponNode = SCNNode(geometry: SCNBox(width: 0.3, height: 0.3, length: 0.3, chamferRadius: 0))
    var startingPoint = SCNNode()
    
    let localStorage = UserDefaults.standard
    var positionFixed = false
    
    // check if user can get coupon
    @IBAction func cameraButton(_ sender: Any) {
        let n = SCNNode()
        let curFrame = self.sceneView.session.currentFrame
        let curCameraTransform = SCNMatrix4(curFrame!.camera.transform)
        n.transform = curCameraTransform
        //        let orientation = n.orientation
        let position = n.position
        if (abs(position.x - CouponNode.position.x) < 1) && (abs(position.y - CouponNode.position.y) < 1) && (abs(position.z - CouponNode.position.z) < 1) {
            // congratulation infomaton
            let Vwidth = self.WholeView.frame.size.width
            let Vheight = self.WholeView.frame.size.height
            infoLabel2.alpha = 0
            let info = "You have grabbed it!"//You have grabbed the coupon!            
            
            // add coupon to collection
            let couponString = localStorage.string(forKey: "couponSelected")!
            
            var userCouponCollection: [String] = localStorage.object(forKey: "myCouponList") as! [String]
            userCouponCollection.append(couponString)
            localStorage.set(userCouponCollection, forKey: "myCouponList")
            
            
            self.infoLabel.text = info
            self.infoLabel.numberOfLines = 0
            self.infoLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
            self.infoLabel.backgroundColor = UIColor.white
            
            WholeView.bringSubviewToFront(infoView)
            infoView.bringSubviewToFront(infoLabel)
            
            
            let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeIn)
            {
                self.infoView.alpha = 1
                self.infoView.center = CGPoint(x: Vwidth / 2, y: Vheight / 2)
                
            }
            animator.startAnimation()
        } else {
            infoLabel2.text = "please come closer!"
            infoLabel2.alpha = 0.5
        }
        print(position)
    }
    
    // add one coupon nearby
    func grabCouponEventListener() {
        if positionFixed {
            return
        }
        positionFixed = true
        infoLabel2.text = "Now click on Get if you find a white cube!"
        infoLabel2.backgroundColor = UIColor.gray
        infoLabel2.alpha = 0.5
        
        let frame = self.sceneView.session.currentFrame
        let cameraTransform = SCNMatrix4(frame!.camera.transform)
        self.startingPoint.transform = cameraTransform
        
        let List = [-1.0,1.0]
        let flagX = Int.random(in: 0..<2)
        let flagY = Int.random(in: 0..<2)
        let flagZ = Int.random(in: 0..<2)
        let X = Float(List[flagX]) * Float.random(in: 0..<2)
        let Y = Float(List[flagY]) * Float.random(in: 0..<2)
        let Z = Float(List[flagZ]) * Float.random(in: 0..<1)
        CouponNode.position = SCNVector3(X,Y,Z) // in meters
        sceneView.scene.rootNode.addChildNode(CouponNode)
    }
    override func viewDidLoad() {
        // bad setting
        super.viewDidLoad()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        infoView.alpha = 0
        // reminder
        infoLabel2.text = "Please click on Add"
        infoLabel2.backgroundColor = UIColor.gray
        infoLabel2.alpha = 0.5
        
        OKButton.addTarget(self, action: #selector(OKButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        grabCouponEventListener()
    }
    
    
    
    
    @objc func OKButtonTapped(_ sender: Any){
        // dismiss
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
