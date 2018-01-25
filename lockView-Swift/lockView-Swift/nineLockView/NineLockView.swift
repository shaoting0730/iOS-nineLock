//
//  NineLockView.swift
//  lockView-Swift
//
//  Created by Shaoting Zhou on 2018/1/25.
//  Copyright © 2018年 Shaoting Zhou. All rights reserved.
//

import UIKit

let btnCount = 9; //九宫格个数
let btnW:CGFloat = 74.0;    //单个按钮宽
let btnH:CGFloat = 74.0;    //单个按钮高
let viewY:CGFloat = 300.0;  //视图Y
let columnCount = 3;   //列数
let kScreenHeight = UIScreen.main.bounds.size.height
let kScreenWidth = UIScreen.main.bounds.size.width

//创建协议
protocol nineLockViewDelegate:NSObjectProtocol
{
    func lockView(lockView:NineLockView,path:String)
}

class NineLockView: UIView {
    weak var delegate:nineLockViewDelegate?
    var selectBtnsAry = [UIButton] ()
    var currentPoint:CGPoint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self .addButton();
    }
    
    // MARK: 添加按钮
    func addButton(){
        var height:CGFloat = 0.0
        for var i in 0 ..< btnCount{
            let btn = UIButton.init(type: .custom)
            btn.setImage(#imageLiteral(resourceName: "gesture_normal"), for: .normal)  //默认图片
            btn.setImage(#imageLiteral(resourceName: "gesture_selected"), for: .selected)  //选中图片
            btn.tag = i
            btn.isUserInteractionEnabled = false  //取消用户交互
            let row = i / columnCount  //行数
            let column = i % columnCount //列数
            let margin:CGFloat = (self.frame.size.width - CGFloat(columnCount) * btnW) / CGFloat( (columnCount + 1)); //边距
            let btnX:CGFloat = margin + CGFloat(column) * (btnW + margin);   //x轴
            let btnY:CGFloat = CGFloat(row) * (btnW + margin);       //y轴
            btn.frame = CGRect.init(x: btnX, y: btnY, width: btnW, height: btnH)
            height = btnY + btnH   //视图的高 = 最后一个按钮的高 + y
            self.addSubview(btn)
        }
        self.frame = CGRect.init(x: 0, y: viewY, width: kScreenWidth, height: height)
    }
    
    func pointWithTouch(touches:Set<UITouch>) -> CGPoint{
        let touch:UITouch = (touches as NSSet).anyObject() as! UITouch
        let point = touch.location(in: self)
        return point;
    }
    func buttonWithPoint(point:CGPoint) -> UIButton?{
        for var view:UIView in self.subviews {
            let btn:UIButton =  view as! UIButton
            if(btn.frame.contains(point)){
                return btn
            }
        }
        return nil
    }
    
    
    // MARK:  开始移动
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //1.拿到触摸的点
        let point:CGPoint = self.pointWithTouch(touches: touches)
        //2.根据触摸的点拿到相应的按钮
        guard let btn:UIButton = self.buttonWithPoint(point: point) else{
            return;
        }
        //3.设置状态
        if(btn.isSelected == false){
            btn.isSelected  = true
            self.selectBtnsAry.append(btn)
        }
        
    }
    
    // MARK:  移动中
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //1.拿到触摸的点
        let point:CGPoint = self.pointWithTouch(touches: touches)
        //2.根据触摸的点拿到相应的按钮
        guard let btn:UIButton = self.buttonWithPoint(point: point) else{
            return;
        }
        //3.设置状态
        if(btn.isSelected == false){
            btn.isSelected  = true
            self.selectBtnsAry.append(btn)
        }else{
            self.currentPoint = point;
        }
        self.setNeedsDisplay()

    }
    // MARK:  移动停止
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if delegate != nil{
            var str = "";
            for var i in 0 ..< self.selectBtnsAry.count{
                let btn:UIButton = self.selectBtnsAry[i]
                str = str  + String(btn.tag)
            }
            self.delegate?.lockView(lockView: self, path: str)
        }
        
        for var i in 0 ..< self.selectBtnsAry.count{
            let btn:UIButton = self.selectBtnsAry[i]
            btn.isSelected = false
        }
        self.selectBtnsAry.removeAll()
        self.setNeedsDisplay()
    }
    
    // MARK:  移动取消
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchesEnded(touches, with: event)
    }
    
    // MARK:  绘图
    override func draw(_ rect: CGRect) {
        if(self.selectBtnsAry.count == 0){
            return;
        }
        let  path:UIBezierPath = UIBezierPath.init()
        path.lineWidth = 8
        path.lineJoinStyle = .round
        UIColor.init(red: 32/255.0, green: 210/255.0, blue: 254/255.0, alpha: 0.5).set()
        //遍历按钮
        for var i in 0 ..< self.selectBtnsAry.count{
            let btn:UIButton = self.selectBtnsAry[i]
            if(i == 0){
                //起点
                path.move(to: btn.center)
            }else{
                //划线
                path.addLine(to: btn.center)
            }
        }
        path.addLine(to: self.currentPoint) //最后一点 连接自己
        path.stroke()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
