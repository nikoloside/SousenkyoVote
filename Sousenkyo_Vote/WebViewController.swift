//
//  WebViewController.swift
//  Sousenkyo_Vote
//
//  Created by Yuhang Huang on 2015/05/18.
//  Copyright (c) 2015年 Niko Kou@LOS_studio. All rights reserved.
//


import UIKit

protocol webViewControllerDelegate{
    func webDidFinished()
}


class WebViewController: UIViewController, UIWebViewDelegate {
    
    var finish = false;
    //serialnumber
    var text1 = ""
    var text2 = ""
    //jscode
    var js1 = "document.getElementById('form_serialnum1').value="
    var js2 = "document.getElementById('form_serialnum2').value="
    //jslink
    var jslink = "http://megalodon.jp/2014-0606-1419-08/akb48-sousenkyo2014.jp/web/akb2014/vote/"
    var jslink_w = "show?c=10416"
    var submit = "document.getElementById('form_serialnum1').parentNode.parentNode.submit()"
    var submitornot = false
    var delegate: webViewControllerDelegate! = nil
    private var myWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.orangeColor()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        // WebViewを生成.
        myWebView = UIWebView()
        
        // Delegateを設定する.
        myWebView.delegate = self
        
        // WebViewのサイズを設定する.
        myWebView.frame = self.view.bounds
        
        // Viewに追加する.
        self.view.addSubview(myWebView)
        
        //閉じるボタンを作る
        let closeBtn = UIButton(frame: CGRectMake(0, 0, 300, 50))
        //closeBtn.layer.position = CGPoint(x: self.view.frame.width/2, y:self.view.frame.height - 50)
        closeBtn.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height/2+50)
        closeBtn.setTitle(NSLocalizedString("CLOSE", comment: "comment"), forState: .Normal)
        closeBtn.layer.backgroundColor = UIColor(red: 0.000, green: 0.549, blue: 0.890, alpha: 0.8).CGColor
        closeBtn.addTarget(self, action: #selector(WebViewController.close(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(closeBtn)
        
        // URLを設定する.
        let url: NSURL = NSURL(string: jslink + jslink_w)!
//        println(jslink_w)
        // リクエストを作成する.
        let request: NSURLRequest = NSURLRequest(URL: url)
        
        // リクエストを実行する.
        myWebView.loadRequest(request)
        
        
    }
    
    /*
    Pageがすべて読み込み終わった時呼ばれるデリゲートメソッド.
    */
    func webViewDidFinishLoad(webView: UIWebView) {
//        println("webViewDidFinishLoad")
        if(finish){
            myWebView.delegate = nil
            myWebView.removeFromSuperview()
            myWebView = nil
            finish = false
        
        }else{
            let js1_input = js1 + "'" + self.text1 + "'";
            webView.stringByEvaluatingJavaScriptFromString(js1_input)
            let js2_input = js2 + "'" + self.text2 + "'";
            webView.stringByEvaluatingJavaScriptFromString(js2_input)
            
            if self.submitornot {
                //AdHocバージョン専用機能
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue()) {
                    webView.stringByEvaluatingJavaScriptFromString(self.submit)
                }
            }
            
        }
    }
    
    /*
    Pageがloadされ始めた時、呼ばれるデリゲートメソッド.
    */
    func webViewDidStartLoad(webView: UIWebView) {
//        println("webViewDidStartLoad")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func close(sender: UIButton){
        closeall()
    }
    
    func closeall(){
        
        myWebView.stopLoading()
        
        finish = true;
        let url: NSURL = NSURL(string: "about:blank")!
        let request: NSURLRequest = NSURLRequest(URL: url)
        myWebView.loadRequest(request)
        self.delegate.webDidFinished()
    }
    
}