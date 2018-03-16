//
//  ThirdViewController.swift
//  Sousenkyo_Vote
//
//  Created by Yuhang Huang on 2015/05/18.
//  Copyright (c) 2015年 Niko Kou@LOS_studio. All rights reserved.
//

import UIKit
import AVFoundation

class ThirdViewController: UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate,G8TesseractDelegate,ModalViewControllerDelegate,webViewControllerDelegate {
    
    
    let MemberButton = UIButton(frame: CGRectMake(0,0,240,50))
    let TeamButton = UIButton(frame: CGRectMake(0,0,240,50))
    var MemberNumber = 0
    //Json設定
    var Json: JSON = JSON("")
    //保存選択肢
    var nosave : Bool = true
    // セッション.
    var mySession : AVCaptureSession!
    // デバイス.
    var myDevice : AVCaptureDevice!
    // 画像のアウトプット.
    var myImageOutput : AVCaptureVideoDataOutput!
    var myImageinput:AVCaptureDeviceInput!
    var imageView:UIImageView!
    
    let tempview:UIView = UIView()
    
    override func viewDidAppear(animated: Bool) {
        
        UIView.animateWithDuration(1.0, animations: {
            self.tempview.backgroundColor =  UIColor(red: 0.000, green: 0.549, blue: 0.890, alpha: 0.0)
        })
        
        mySession.startRunning()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        /*   Viewのサイズや属性に関する設定   */
        //Json設定
        self.webview.jslink = Json["Total"][1].asString!
        self.webview.js1 = Json["Total"][2].asString!
        self.webview.js2 = Json["Total"][3].asString!
        self.webview.submit = Json["Total"][4].asString!
        
        //各rectの設定
        let width:CGFloat = self.view.bounds.width
        let height:CGFloat = self.view.bounds.height
        
        let rectTarget = CGRect(x: 0, y: 0, width: width - 50, height: (width - 50)/8)
        let rectWhite = CGRect(x: 0, y: 0, width: width, height: height/2 - rectTarget.height - 50)
 //       let rectView = CGRect(x: 0, y: 0, width: width, height: height/2-100)
        let rectFunc = CGRect(x: 0, y: 0, width: width, height: height/2)
        
        
        // Controllerのタイトルを設定する.
        self.title = "　"
        
        // Viewの背景色を定義する.
        self.view.backgroundColor = UIColor.purpleColor()
        
        /*   カメラのセッションを初期化   */
        
        // セッションの作成.
        mySession = AVCaptureSession()
        
        mySession.sessionPreset = AVCaptureSessionPresetHigh
        
        // デバイス一覧の取得.
        let devices = AVCaptureDevice.devices()
        
        // バックカメラをmyDeviceに格納.
        for device in devices{
            if(device.position == AVCaptureDevicePosition.Back){
                myDevice = device as! AVCaptureDevice
            }
        }
        
        // バックカメラからVideoInputを取得
        do{
            let videoInput = try AVCaptureDeviceInput(device: myDevice) as AVCaptureDeviceInput
            // セッションに追加.
            if (mySession.canAddInput(videoInput)) {
                mySession.addInput(videoInput)
            }
        } catch {
        }
        
        // 出力先を生成.
        myImageOutput = AVCaptureVideoDataOutput()
        
        // セッションに追加.
        if (mySession.canAddOutput(myImageOutput)){
            mySession.addOutput(myImageOutput)
        }
        
        // 画像を表示するレイヤーを生成
        imageView = UIImageView()
        imageView.frame = self.view.bounds
        
        // UIImageViewをビューに追加
        self.view.addSubview(self.imageView)
        // ピクセルフォーマットを 32bit BGR + A とする
        myImageOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey : Int(kCVPixelFormatType_32BGRA)]
        
        // フレームをキャプチャするためのサブスレッド用のシリアルキューを用意
        myImageOutput.setSampleBufferDelegate(self, queue: dispatch_get_main_queue())
        
        myImageOutput.alwaysDiscardsLateVideoFrames = true
        
        // セッション開始.
        
        /* 各SubViewの作成. */
        
        tempview.frame = self.view.bounds
        
        tempview.backgroundColor = UIColor(red: 0.000, green: 0.549, blue: 0.890, alpha: 1.0)
        
        self.view.addSubview(tempview)
        
        //説明文字のsubview
        
        let layerView = UILabel(frame: rectWhite)
        //背景のいろ
        layerView.layer.backgroundColor = UIColor(red: 0.000, green: 0.549, blue: 0.890, alpha: 0.8).CGColor
        //文字の内容
        layerView.text = NSLocalizedString("TIPS", comment: "comment")
        layerView.numberOfLines = 3
        layerView.textColor = UIColor.whiteColor()
        layerView.shadowColor = UIColor.grayColor()
        layerView.textAlignment = NSTextAlignment.Center
        // 配置する座標を設定する.
        layerView.layer.position = CGPoint(x: width/2,y: rectWhite.height/2)
        self.view.addSubview(layerView)
        
        
        //rect枠のsubview
        
        let targetView = UIView(frame: rectTarget)
        //枠の設定
        targetView.layer.borderWidth = 2.0
        targetView.layer.borderColor = UIColor.whiteColor().CGColor
        
        targetView.layer.position = CGPoint(x: width/2,y: rectWhite.height + rectTarget.height/2 + 25)
        self.view.addSubview(targetView)
        
        
        //FuncViewの生成
        
        let funcView = UIView(frame: rectFunc)
        //枠の設定
        funcView.layer.backgroundColor = UIColor(red: 0.000, green: 0.549, blue: 0.890, alpha: 0.8).CGColor
        
        funcView.layer.position = CGPoint(x: width/2,y: height/2 + rectFunc.height/2)
        self.view.addSubview(funcView)
        
        
        /* ボタンの作成. */
        
        //撮影ボタン
        
        let myButton = UIButton(frame: CGRectMake(0,0,120,50))
        myButton.layer.masksToBounds = true
        myButton.setTitle(NSLocalizedString("CEMERA", comment: "comment"), forState: .Normal)
        myButton.layer.cornerRadius = 20.0
        myButton.layer.borderWidth = 2.0
        myButton.layer.borderColor = UIColor.whiteColor().CGColor
        myButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height/2+50)
        myButton.addTarget(self, action: #selector(ThirdViewController.onClickMyButton(_:)), forControlEvents: .TouchUpInside)
        
        //ライトボタン
        let lightButton = UIButton(frame: CGRectMake(0,0,50,50))
        lightButton.layer.masksToBounds = true
        lightButton.setTitle("", forState: .Normal)
        lightButton.layer.cornerRadius = 40.0
        lightButton.layer.borderWidth = 2.0
        lightButton.layer.borderColor = UIColor.whiteColor().CGColor
        lightButton.layer.position = CGPoint(x: self.view.bounds.width - 70, y:self.view.bounds.height/2+50)
        lightButton.addTarget(self, action: #selector(ThirdViewController.onClicklightButton(_:)), forControlEvents: .TouchUpInside)
        
        
        //Saveボタン
        let saveButton = UIButton(frame: CGRectMake(0,0,50,50))
        saveButton.layer.masksToBounds = true
        saveButton.setTitle("", forState: .Normal)
        saveButton.layer.cornerRadius = 40.0
        saveButton.layer.borderWidth = 2.0
        saveButton.layer.borderColor = UIColor.whiteColor().CGColor
        saveButton.layer.position = CGPoint(x: 70, y:self.view.bounds.height/2+50)
        saveButton.addTarget(self, action: #selector(ThirdViewController.onClicksaveButton(_:)), forControlEvents: .TouchUpInside)
        
        //Teamボタン
        TeamButton.layer.masksToBounds = true
        TeamButton.setTitle("Team4", forState: .Normal)
        TeamButton.layer.cornerRadius = 40.0
        TeamButton.layer.borderWidth = 2.0
        TeamButton.layer.borderColor = UIColor.whiteColor().CGColor
        TeamButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height/2+self.view.bounds.height/5+40)
        TeamButton.addTarget(self, action: #selector(ThirdViewController.onClickTeamButton(_:)), forControlEvents: .TouchUpInside)
        
        //Memberボタン
        MemberButton.layer.masksToBounds = true
        MemberButton.setTitle("高橋 朱里", forState: .Normal)
        MemberButton.layer.cornerRadius = 40.0
        MemberButton.layer.borderWidth = 2.0
        MemberButton.layer.borderColor = UIColor.whiteColor().CGColor
        MemberButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height/2+self.view.bounds.height/5*2)
        MemberButton.addTarget(self, action: #selector(ThirdViewController.onClickMemberButton(_:)), forControlEvents: .TouchUpInside)
        
        // UIボタンをViewに追加.
        self.view.addSubview(myButton)
        self.view.addSubview(lightButton)
        self.view.addSubview(saveButton)
        self.view.addSubview(TeamButton)
        self.view.addSubview(MemberButton)
        
        /* Mode1とMode2の分岐. */
        
        //Mode1
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /* ボタンイベント. */
    
    func onClickTeamButton(sender: UIButton){
        
        // インスタンス生成　styleはActionSheet.
        let myAlert = UIAlertController(title: NSLocalizedString("TEAM", comment: "comment"), message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        for (key, _) in Json {
            // k is NSString, v is another JSON object
            if key as! String != "Total" {
                let myAction = UIAlertAction(title: key as? String, style: UIAlertActionStyle.Default, handler: {
                    (action: UIAlertAction) in
                    sender.setTitle(key as? String, forState: .Normal)
                    self.MemberButton.setTitle(self.Json[key as! String][0]["Name"].asString, forState: .Normal)
                    self.MemberNumber = 0
                })
                myAlert.addAction(myAction)
            }
        }
        // アクションを生成.
        
        
        let myAction_no = UIAlertAction(title: NSLocalizedString("CANCEL", comment: "comment"), style: UIAlertActionStyle.Cancel, handler: {
            (action: UIAlertAction) in
        })
        
        // アクションを追加.
        myAlert.addAction(myAction_no)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
        
    }
    
    func onClickMemberButton(sender: UIButton){
        // インスタンス生成　styleはActionSheet.
        let myAlert = UIAlertController(title: NSLocalizedString("MEMBER", comment: "comment"), message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        for (i, member) in Json[self.TeamButton.currentTitle!] {
            // k is NSString, v is another JSON object
            let membername = member["Name"].asString
            let myAction = UIAlertAction(title: membername!, style: UIAlertActionStyle.Default, handler: {
                (action: UIAlertAction) in
                sender.setTitle(membername, forState: .Normal)
                self.MemberNumber = i as! Int
            })
                myAlert.addAction(myAction)
        }
        // アクションを生成.
        
        
        let myAction_no = UIAlertAction(title: NSLocalizedString("CANCEL", comment: "comment"), style: UIAlertActionStyle.Cancel, handler: {
            (action: UIAlertAction) in
        })
        
        // アクションを追加.
        myAlert.addAction(myAction_no)
        
        self.presentViewController(myAlert, animated: true, completion: nil)
        
    }
    
    func onClicksaveButton(sender: UIButton){
        
        if nosave {
            nosave = false
            sender.setTitle(NSLocalizedString("SAVE", comment: "comment"), forState: .Normal)
        }else {
            nosave = true
            sender.setTitle("", forState: .Normal)
        }
        
    }
    
    func onClicklightButton(sender: UIButton){
        
        
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do {
            try device.lockForConfiguration()
        } catch _ {
        }
        if device.hasTorch{
            if device.torchMode == AVCaptureTorchMode.On {
                device.torchMode = AVCaptureTorchMode.Off //On
                sender.setTitle("", forState: .Normal)
            }else {
                device.torchMode = AVCaptureTorchMode.On //On
                sender.setTitle("＊", forState: .Normal)
            }
        }else {
            
            let myAlert: UIAlertController = UIAlertController(title: NSLocalizedString("ERROR", comment: "comment"), message: NSLocalizedString("NO_LIGHT", comment: "comment"), preferredStyle: .Alert)
            // OKのアクションを作成する.
            let myOkAction = UIAlertAction(title: "OK", style: .Default) { action in
            }
            // OKのActionを追加する.
            myAlert.addAction(myOkAction)
            // UIAlertを発動する.
            presentViewController(myAlert, animated: true, completion: nil)
            
        }
        //device.torchMode = AVCaptureTorchMode.On //Off
        device.unlockForConfiguration()
    }
    
    func onClickMyButton(sender: UIButton){
        
        // ビデオ出力に接続.
        if var _:AVCaptureConnection? = myImageOutput.connectionWithMediaType(AVMediaTypeVideo){
            /*
             // アルバムに追加
             // 取得したImageのDataBufferをJpegに変換.
             let myImageData : NSData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataBuffer)
             
             // JpegからUIIMageを作成.
             let myImage : UIImage = UIImage(data: myImageData)!
             */
            let myImage : UIImage = self.imageView.image!
            UIGraphicsBeginImageContext(myImage.size)
            myImage.drawInRect(CGRectMake(0, 0, myImage.size.width, myImage.size.height))
            let originImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            //切り抜き処理
            let imageX : CGFloat = myImage.size.width * 25 / self.view.bounds.width
            let imageY : CGFloat = myImage.size.height * (self.view.bounds.height/2 - (self.view.bounds.width - 50) / 8 - 25 ) / self.view.bounds.height
            let imageW : CGFloat = myImage.size.width * (self.view.bounds.width - 50) / self.view.bounds.width
            let imageH : CGFloat = myImage.size.height * (self.view.bounds.width - 50) / 8 / self.view.bounds.height
            let targetRef = CGImageCreateWithImageInRect(originImage.CGImage, CGRectMake(imageX, imageY, imageW, imageH))
            
            let newImage = TOpenCV.DetectWithImage(UIImage(CGImage: targetRef!))
            
            // OCRに渡す.
            let tesseract:G8Tesseract = G8Tesseract(language:"amh")
            tesseract.language = "amh";
            tesseract.delegate = self
            tesseract.charWhitelist = "123456789 abcdefghijklmnopqrstuvwxyz"
            tesseract.image = newImage
            tesseract.recognize()
            //　NSLog("%@", tesseract.recognizedText);
            let targettext = tesseract.recognizedText.componentsSeparatedByString("\n")
            self.makeAlert(newImage!, text: targettext[0] + " error")
//            println(tesseract.recognizedText)
            //　Alertview生成
        }
    }
    
    /* 各FuncViewの初期化 */
    
    
    let modalView = ModalViewController()
    
    private func makeAlert(image : UIImage, text : String){
        
        self.modalView.delegate = self
        modalView.imageview.image = image
        //let testtext = text + " error"
        let text_sep = text.componentsSeparatedByString(" ")
        modalView.text1.text = text_sep[0]
        modalView.text2.text = text_sep[1]
        
        
        self.presentViewController(modalView, animated: true, completion: nil)
    }
    
    
    //ウエブview
    let webview = WebViewController()
    
    func modalDidFinished(modalText1: String, modalText2: String){
        
        modalView.dismissViewControllerAnimated(true, completion: nil)
        self.modalView.delegate = nil
        modalView.imageview.image = nil
        modalView.text1.text = nil
        modalView.text2.text = nil
        
        
        if modalText1 != "" && modalText2 != "error" {
            self.webview.delegate = self
            self.webview.text1 = modalText1
            self.webview.text2 = modalText2
            self.webview.jslink_w = Json[self.TeamButton.currentTitle!][self.MemberNumber]["Url"].asString!
            if !self.nosave {
                self.webview.submitornot = true
            } else {
                self.webview.submitornot = false
            }
//            println(self.MemberNumber)
            self.presentViewController(self.webview, animated: true, completion: nil)
        }
        
    }
    
    func webDidFinished(){
        self.webview.delegate = nil
        self.webview.text1 = ""
        self.webview.text2 = ""
        self.webview.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /* camera実装 */
    // 新しいキャプチャの追加で呼ばれる
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        
        // キャプチャしたsampleBufferからUIImageを作成
        let image:UIImage = self.captureImage(sampleBuffer)
        
        // 画像を画面に表示
        dispatch_async(dispatch_get_main_queue()) {
            self.imageView.image = image
            
        }
    }
    
    func captureImage(sampleBuffer:CMSampleBufferRef) -> UIImage{
        
        // Sampling Bufferから画像を取得
        let imageBuffer:CVImageBufferRef = CMSampleBufferGetImageBuffer(sampleBuffer)!
        
        // pixel buffer のベースアドレスをロック
        CVPixelBufferLockBaseAddress(imageBuffer, 0)
        
        let baseAddress:UnsafeMutablePointer<Void> = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0)
        
        let bytesPerRow:Int = CVPixelBufferGetBytesPerRow(imageBuffer)
        let width:Int = CVPixelBufferGetWidth(imageBuffer)
        let height:Int = CVPixelBufferGetHeight(imageBuffer)
        
        
        // 色空間
        let colorSpace:CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()!
        
        let bitsPerCompornent:Int = 8
        
        // swift 2.0
        let newContext:CGContextRef = CGBitmapContextCreate(baseAddress, width, height, bitsPerCompornent, bytesPerRow, colorSpace,  CGImageAlphaInfo.PremultipliedFirst.rawValue|CGBitmapInfo.ByteOrder32Little.rawValue)!
        
        let imageRef:CGImageRef = CGBitmapContextCreateImage(newContext)!
        let resultImage = UIImage(CGImage: imageRef, scale: 1.0, orientation: UIImageOrientation.Right)
        
        return resultImage
    }

    
}