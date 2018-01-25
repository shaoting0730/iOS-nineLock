//
//  ViewController.swift
//  lockView-Swift
//
//  Created by Shaoting Zhou on 2018/1/25.
//  Copyright © 2018年 Shaoting Zhou. All rights reserved.
//

import UIKit

class ViewController: UIViewController,nineLockViewDelegate  {
    
    
    let kScreenHeight = UIScreen.main.bounds.size.height
    let kScreenWidth = UIScreen.main.bounds.size.width
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.brown
        let nineLockView = NineLockView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        nineLockView.delegate = self
        self.view.addSubview(nineLockView)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    //MARK: - 代理方法
    func lockView(lockView: NineLockView, path: String) {
        if(path.description.count < 4){
            print("至少连4个");
            return;
        }
        if(path == "01258"){
            print("密码正确");
        }else{
            print("密码错误");
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

