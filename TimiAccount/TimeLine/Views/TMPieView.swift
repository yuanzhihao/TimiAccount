//
//  TMPieView.swift
//  TimiAccount
//
//  Created by Zhihao Yuan on 2017/7/2.
//  Copyright © 2017年 Zhihao Yuan. All rights reserved.
//

import UIKit
import SnapKit

typealias SwiftBlock = () -> Void

class TMPieView: UIView {
    
    let animationTime = 1.0
    
    var sections: Array<Double>? = []
    
    var sectionColors: Array<UIColor>? = []
    
    var spacing: CGFloat = 0.0
    
    var lineWidth: CGFloat = 0.0
    
    var animationStrokeColor: UIColor? = nil
    
    var shapeLayer: CAShapeLayer? = nil
    
    var containerLayer: CAShapeLayer? = nil
    
    var completeAnimation = false
    
    var completion: SwiftBlock? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.lineWidth = 8
        self.spacing = 6
        self.animationStrokeColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        self.drawPieWithAnimation()
    }
    
    private func drawPieWithAnimation() {
        self.containerLayer = nil
        let path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.bounds.size.height / 2)
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.strokeColor = UIColor.white.cgColor
        layer.fillColor = UIColor.white.cgColor
        self.layer.addSublayer(layer)
        self.containerLayer = layer
        
        let count = self.sections!.count
        var total: Double = 0.0, startAngle: Double = .pi / 2, endAngle: Double = 0.0
        for section in self.sections! {
            total += section
        }
        let center = CGPoint(x: self.bounds.origin.x + self.bounds.size.width / 2, y: self.bounds.origin.y + self.bounds.size.height / 2)
        for index in 0..<count {
            let scale = self.sections![index] / total
            let color = self.sectionColors![index]
            endAngle = startAngle + scale * 2 * .pi
            
            let fanShapedPath = UIBezierPath(arcCenter: center, radius: (self.bounds.size.height - self.spacing) / 2, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true)
            
            let fanShapedLayer = CAShapeLayer()
            fanShapedLayer.lineWidth = self.lineWidth
            fanShapedLayer.path = fanShapedPath.cgPath
            fanShapedLayer.fillColor = UIColor.clear.cgColor
            fanShapedLayer.strokeColor = color.cgColor
            
            startAngle = endAngle
            layer.addSublayer(fanShapedLayer)
        }
        
        let baseAnimation = CABasicAnimation(keyPath: "strokeEnd")
        baseAnimation.fromValue = 1.0
        baseAnimation.toValue = 0.0
        baseAnimation.duration = animationTime
        
        let coverPath = UIBezierPath(arcCenter: center, radius: (self.bounds.size.height - self.spacing) / 2, startAngle: .pi / 2, endAngle: -2 * .pi + .pi / 2, clockwise: false)
        let coverLayer = CAShapeLayer()
        coverLayer.path = coverPath.cgPath
        coverLayer.lineWidth = self.lineWidth
        coverLayer.fillColor = UIColor.clear.cgColor
        coverLayer.strokeColor = self.animationStrokeColor!.cgColor
        
        baseAnimation.isRemovedOnCompletion = false
        baseAnimation.fillMode = kCAFillModeForwards
        layer.addSublayer(coverLayer)
        coverLayer.add(baseAnimation, forKey: "coverLayer")
        self.shapeLayer = coverLayer
    }
    
    func reloadDataCompletion(block: @escaping () -> Void) -> Void {
        self.drawPieWithAnimation()
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: DispatchTime.now() + animationTime * Double(NSEC_PER_SEC), execute: block)
    }
    
    func getLayerIndex(point: CGPoint) -> Int {
        for i in 0..<self.containerLayer!.sublayers!.count {
            let layer = self.containerLayer!.sublayers![i] as! CAShapeLayer
            let path = layer.path
            if path!.contains(point) {
                return i
            }
        }
        return -1
    }
    
    func getLayerCenterPoint(point: CGPoint) -> CGPoint {
        var centerPoint: CGPoint? = nil
        var allLayers = self.containerLayer!.sublayers!
        allLayers.removeLast()
        allLayers.forEach { (CALayer) in
            let layer = CALayer as! CAShapeLayer
            let path = layer.path!
            if path.contains(point) {
                centerPoint = CGPoint(x: layer.position.x - (layer.anchorPoint.x - 0.5) * layer.bounds.size.width, y: layer.position.y - (layer.anchorPoint.y - 0.5) * layer.bounds.size.height)
            }
        }
        return centerPoint!
    }
    
    func dismissAnimationByTimeInterval(time: TimeInterval) {
        let baseAnimation = CABasicAnimation(keyPath: "strokeEnd")
        baseAnimation.duration = time
        if self.completeAnimation {
            self.completeAnimation = false
            baseAnimation.fromValue = 1.0
            baseAnimation.toValue = 0.0
        }
        else {
            self.completeAnimation = true
            baseAnimation.fromValue = 0.0
            baseAnimation.toValue = 1.0
        }
        baseAnimation.isRemovedOnCompletion = false
        baseAnimation.fillMode = kCAFillModeForwards
        self.shapeLayer!.add(baseAnimation, forKey: nil)
    }
    
    deinit {
        self.shapeLayer!.removeAllAnimations()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
