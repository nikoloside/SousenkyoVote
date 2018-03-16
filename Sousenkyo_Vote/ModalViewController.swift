//
//  ModalViewController.swift
//  Sousenkyo_Vote
//
//  Created by Yuhang Huang on 2015/05/17.
//  Copyright (c) 2015年 Niko Kou@LOS_studio. All rights reserved.
//
import UIKit

protocol ModalViewControllerDelegate{
    func modalDidFinished(modalText1: String, modalText2: String)
}

class ModalViewController: UIViewController, UITextFieldDelegate,GADBannerViewDelegate {
    
    var delegate: ModalViewControllerDelegate! = nil
    let text1 = UITextField()
    let text2 = UITextField()
    let imageview = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor(red: 0.000, green: 0.549, blue: 0.890, alpha: 1.0)
        
        self.imageview.frame = CGRectMake(0,0,self.view.frame.width - 50, (self.view.frame.width - 50) / 8)
        self.imageview.layer.position = CGPoint(x: self.view.frame.width/2, y:self.view.frame.height*1/7)
        self.view.addSubview(imageview)
        
        self.text1.frame = CGRectMake(0, 0, 300, 50)
        self.text1.layer.position = CGPoint(x: self.view.frame.width/2, y:self.view.frame.height*2/7)
        self.text1.backgroundColor = UIColor.whiteColor()
        self.text1.delegate = self
        self.view.addSubview(self.text1)
        
        self.text2.frame = CGRectMake(0, 0, 300, 50)
        self.text2.layer.position = CGPoint(x: self.view.frame.width/2, y:self.view.frame.height*3/7)
        self.text2.backgroundColor = UIColor.whiteColor()
        self.text2.delegate = self
        self.view.addSubview(self.text2)
        
        let submitBtn = UIButton(frame: CGRectMake(0, 0, 300, 50))
        //submitBtn.layer.position = CGPoint(x: self.view.frame.width/2, y:self.view.frame.height*4/6)
        submitBtn.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height/2+50)
        submitBtn.setTitle(NSLocalizedString("SUBMIT", comment: "comment"), forState: .Normal)
        submitBtn.layer.borderWidth = 2.0
        submitBtn.layer.cornerRadius = 20.0
        submitBtn.layer.borderColor = UIColor.whiteColor().CGColor
        submitBtn.addTarget(self, action: #selector(ModalViewController.submit(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(submitBtn)
        
        let cancelBtn = UIButton(frame: CGRectMake(0, 0, 300, 50))
        cancelBtn.layer.position = CGPoint(x: self.view.frame.width/2, y:self.view.frame.height/2+150)
        cancelBtn.setTitle(NSLocalizedString("CANCEL", comment: "comment"), forState: .Normal)
        cancelBtn.layer.borderWidth = 2.0
        cancelBtn.layer.cornerRadius = 20.0
        cancelBtn.layer.borderColor = UIColor.whiteColor().CGColor
        cancelBtn.addTarget(self, action: #selector(ModalViewController.cancel(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(cancelBtn)
        
        //広告
        let origin = CGPointMake(0,0)
        let size = GADAdSizeFullWidthPortraitWithHeight(50) // set size to 50
        let adB = GADBannerView(adSize: size, origin: origin)
        
        adB.adUnitID = "ca-app-pub-6432333526487474/9825326946"
        adB.rootViewController = self
        adB.delegate = self
        self.view.addSubview(adB)
        adB.loadRequest(GADRequest())
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func submit(sender: AnyObject) {
        self.delegate.modalDidFinished(self.text1.text!, modalText2: self.text2.text!)
    }
    
    func cancel(sender: AnyObject) {
        self.delegate.modalDidFinished("", modalText2: "error")
    }
}