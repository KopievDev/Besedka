//
//  emblemView.swift
//  Besedka
//
//  Created by Ivan Kopiev on 29.04.2021.
//
// ПЕЧАЛЬНЫЙ ОПЫТ ((( 
import UIKit
class EmblemView: UIView {

    // main emitter layer
    var emitter = CAEmitterLayer()
    var cell = CAEmitterCell()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup(frame: frame)
    }
    
    func setup(frame: CGRect) {
        // initialization
        emitter.emitterPosition = CGPoint(x: frame.midX, y: frame.midY)
        emitter.emitterShape = CAEmitterLayerEmitterShape.point
        cell.birthRate = 3
        cell.lifetime = 2
        cell.velocity = 100
        cell.scale = 0.3
        cell.emissionRange = CGFloat.pi * 2.0
        cell.spin = -0.5
        cell.spinRange = 1
        cell.contents = UIImage(named: "emblem")?.cgImage
        
        emitter.emitterCells = [cell]
        emitter.beginTime = CACurrentMediaTime()
        emitter.timeOffset = 0
        layer.addSublayer(emitter)

    }
    
    func start() {
        layer.addSublayer(emitter)
    }
    func stop() {
        emitter.removeFromSuperlayer()
        
    }
}
