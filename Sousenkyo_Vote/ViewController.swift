//
//  ViewController.swift
//  Sousenkyo_Vote
//
//  Created by Yuhang Huang on 2015/05/15.
//  Copyright (c) 2015年 Niko Kou@LOS_studio. All rights reserved.
//

import UIKit
import SystemConfiguration//internet situation
import AVFoundation
import AVKit
import AVFoundation

class ViewController: UIViewController {
    
    private let URL_TAR = "http://tk2-240-29725.vs.sakura.ne.jp/nikolos-tool/DataJson"
    private let refreshButton: UIButton! = UIButton()
    private let mode1Button: UIButton! = UIButton()
    private let mode2Button: UIButton! = UIButton()
    
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    
    var player: AVPlayer?
    
    let tempview:UIView = UIView()
    
    override func viewWillAppear(animated: Bool) {
        
        player?.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Controllerのタイトルを設定する.
        self.title = "　"
        
        //videoを敷地にする
        // Load the video from the app bundle.
        let videoURL: NSURL = NSBundle.mainBundle().URLForResource("video", withExtension: "mov")!
        
        player = AVPlayer(URL: videoURL)
        player?.actionAtItemEnd = .None
        player?.muted = true
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerLayer.zPosition = -1
        
        playerLayer.frame = view.frame
        
        view.layer.addSublayer(playerLayer)
        
        player?.play()
        
        //loop video
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(ViewController.loopVideo),
                                                         name: AVPlayerItemDidPlayToEndTimeNotification,
                                                         object: nil)
        
        tempview.frame = self.view.bounds
        
        tempview.backgroundColor = UIColor(red: 0.000, green: 0.549, blue: 0.890, alpha: 0.3)
        
        self.view.addSubview(tempview)
        
        //ホーム画面背景色の設定
        self.view.backgroundColor = UIColor(red: 0.000, green: 0.549, blue: 0.890, alpha: 0.8)
        
        //UIViewController.viewの座標取得
        //var x:CGFloat = self.view.bounds.origin.x
        let y:CGFloat = self.view.bounds.origin.y
        
        //UIViewController.viewの幅と高さを取得
        let width:CGFloat = self.view.bounds.width;
        let height:CGFloat = self.view.bounds.height
        
        //ボタンrefresh生成
        refreshButton.frame = CGRectMake(0,0,width/2,100)
        refreshButton.titleLabel?.numberOfLines = 2
        refreshButton.titleLabel?.textAlignment = NSTextAlignment.Center
        refreshButton.layer.masksToBounds = true
        refreshButton.layer.cornerRadius = 30.0
        refreshButton.layer.borderWidth = 2.0
        refreshButton.layer.borderColor = UIColor.whiteColor().CGColor
        refreshButton.setTitle(NSLocalizedString("REFRESH", comment: "comment"), forState: .Normal)
        refreshButton.titleLabel!.font = UIFont(name: "Helvetica-Bold",size: CGFloat(15))
        refreshButton.layer.position = CGPoint(x: width/2,y: y + height/4)
        refreshButton.addTarget(self, action: #selector(ViewController.onClickRefresh(_:)), forControlEvents: .TouchUpInside)
        
        //ボタン１の生成
        mode1Button.frame = CGRectMake(0,0,width-100,height/2-100)
        mode1Button.layer.masksToBounds = true
        mode1Button.layer.cornerRadius = 130.0
        mode1Button.layer.borderWidth = 2.0
        mode1Button.layer.borderColor = UIColor.whiteColor().CGColor
        mode1Button.setTitle(NSLocalizedString("LIST_MODE", comment: "comment"), forState: .Normal)
        mode1Button.titleLabel!.font = UIFont(name: "Helvetica-Bold",size: CGFloat(30))
        mode1Button.layer.position = CGPoint(x:width/2, y:y + height/5*3)
        mode1Button.addTarget(self, action: #selector(ViewController.onClickMyButton1(_:)), forControlEvents: .TouchUpInside)
        
        //ボタン２の生成
        mode2Button.frame = CGRectMake(0,0,width-100,height/2-100)
        mode2Button.layer.masksToBounds = true
        mode2Button.layer.cornerRadius = 130.0
        mode2Button.layer.borderWidth = 2.0
        mode2Button.layer.borderColor = UIColor.whiteColor().CGColor
        mode2Button.setTitle(NSLocalizedString("VOTE_MODE", comment: "comment"), forState: .Normal)
        mode2Button.titleLabel!.font = UIFont(name: "Helvetica-Bold",size: CGFloat(30))
        mode2Button.layer.position = CGPoint(x:width/2, y:y + height/5*3)
        mode2Button.addTarget(self, action: #selector(ViewController.onClickMyButton2(_:)), forControlEvents: .TouchUpInside)
        
        // ボタンを追加する.
        // spinner 追加
        spinner.frame = CGRect(x: -20, y: 6, width: 20, height: 20)
        spinner.startAnimating()
        spinner.alpha = 0.0
        
        refreshButton.addSubview(spinner)

        self.view.addSubview(refreshButton)
        self.view.addSubview(mode1Button)
        self.view.addSubview(mode2Button)
        
        // リフレッシュ
        refresh()
        
    }
    
    /* 
        補助処理
     */
    
    func CheckReachability(host_name:String)->Bool{
        
        let reachability = SCNetworkReachabilityCreateWithName(nil, host_name)!
        var flags = SCNetworkReachabilityFlags.ConnectionAutomatic
        if !SCNetworkReachabilityGetFlags(reachability, &flags){
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection)
    }
    
    func refresh()->Bool{
        let accessable = CheckReachability(URL_TAR)
        
        let status = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        
        
        if status == AVAuthorizationStatus.Authorized{
            
            if accessable {
                
                
                let json = JSON.fromURL(URL_TAR)
                
                if (json.asError != nil) {
                    
                    let title = NSLocalizedString("REFRESH", comment: "comment") + "\n" + NSLocalizedString("SERVER_WRONG", comment: "comment")
                    refreshButton.setTitle(title, forState: .Normal)
                    mode1Button.hidden = false
                    mode2Button.hidden = true
                    return false
                }
                
                let open = json["Total"][0].asString!
                
                if open == "true" {
                    
                    let title = NSLocalizedString("REFRESH", comment: "comment")
                    refreshButton.setTitle(title, forState: .Normal)
                    mode1Button.hidden = true
                    mode2Button.hidden = false
                    return true
                    
                } else {
                    
                    let title = NSLocalizedString("REFRESH", comment: "comment") + "\n" + NSLocalizedString("OUT_DATE", comment: "comment")
                    refreshButton.setTitle(title, forState: .Normal)
                    mode1Button.hidden = false
                    mode2Button.hidden = true
                    return false
                }
            } else {
                
                let title = NSLocalizedString("REFRESH", comment: "comment") + "\n" + NSLocalizedString("OUT_INTERNET", comment: "comment")
                refreshButton.setTitle(title, forState: .Normal)
                mode1Button.hidden = false
                mode2Button.hidden = true
                return false
            }
        } else {
            
            let title = NSLocalizedString("REFRESH", comment: "comment") + "\n" + NSLocalizedString("NO_CAMERA", comment: "comment")
            refreshButton.setTitle(title, forState: .Normal)
            mode1Button.hidden = true
            mode2Button.hidden = true
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { (granted) in
                if (granted) {
                    // 許可された場合の処理
                    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
                    dispatch_after(delayTime, dispatch_get_main_queue()) {
                        self.refresh()
                    }
                }
            })
            
            return false
        }
    }
    
    func buttonAnimation(){
        let a = refreshButton.bounds
        let b = mode1Button.bounds
        let c = mode2Button.bounds
        
        UIView.animateWithDuration(1.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 20, options: [], animations: {
            // ボタンサイズの変更
            self.refreshButton.bounds = CGRectMake(a.origin.x - 20, a.origin.y, a.size.width + 80, a.size.height)
            self.mode1Button.bounds = CGRectMake(b.origin.x - 20, b.origin.y, b.size.width + 80, b.size.height)
            self.mode2Button.bounds = CGRectMake(c.origin.x - 20, c.origin.y, c.size.width + 80, c.size.height)
            // spinnerのalpha値を変更して表示
            self.spinner.alpha = 1.0
            // spinnerの位置を設定
            self.spinner.center = CGPointMake(40, self.refreshButton.frame.size.height / 2)
            }, completion: nil)
        
        UIView.animateWithDuration(1.0, delay: 1.3, usingSpringWithDamping: 0.2, initialSpringVelocity: 20, options: [], animations: {
            // ボタンサイズを元に戻す
            self.refreshButton.bounds = CGRectMake(a.origin.x, a.origin.y, a.size.width, a.size.height)
            self.mode1Button.bounds = CGRectMake(b.origin.x, b.origin.y, b.size.width, b.size.height)
            self.mode2Button.bounds = CGRectMake(c.origin.x, c.origin.y, c.size.width, c.size.height)
            // spinnerを非表示に
            self.spinner.alpha = 0.0
            }, completion: nil)
    }
    
    func loopVideo() {
        player?.seekToTime(kCMTimeZero)
        player?.play()
    }    /*
     ボタンイベント.
     */
    //    var buttonoff = true
    
    internal func onClickRefresh(sender: UIButton){
        
        refresh()
        buttonAnimation()
    }
    
    internal func onClickMyButton1(sender: UIButton){
        
            // 移動先のViewを定義する.
            let secondViewController = SecondViewController()
        
            // SecondViewに移動する.
            self.navigationController?.pushViewController(secondViewController, animated: true)
        
    }
    
    internal func onClickMyButton2(sender: UIButton){
        
        if refresh() {
            
            let json = JSON.fromURL(URL_TAR)
            
            let thirdViewController = ThirdViewController()
            thirdViewController.Json = json
            // SecondViewに移動する.
            self.navigationController?.pushViewController(thirdViewController, animated: true)
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

