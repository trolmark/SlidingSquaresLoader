//
//  UIConverter.swift
//  SnakeProgressIndicator
//
//  Created by Andrew Denisov on 6/14/17.
//  Copyright © 2017 app.snake.indicator. All rights reserved.
//

import Foundation
import SpriteKit


struct UIBoard {
    
    let config : IndicatorUIConfiguration
    var nodes : [SKShapeNode] = []
    
    init(config:IndicatorUIConfiguration) {
        self.config = config
    }
}

extension UIBoard {
    
    mutating func setupNodes(for board:[Segment]) {
         self.nodes = board.map { self.setupNode(by: $0 ) }
    }
    
    func midPoint(for position:SegmentPosition,
                  relativeTo center:CGPoint) -> CGPoint {
        return CGPoint(x: position.x*config.moveStep() + center.x,
                       y: position.y*config.moveStep() + center.y)
    }
    
    func setupNode(by segment: Segment) -> SKShapeNode {
        
        let smallFrame = CGRect(x: 0, y: 0,
                                width: self.config.segmentSideSize,
                                height: self.config.segmentSideSize)
        
        let midPoint = self.midPoint(for: segment.position,
                                     relativeTo: self.config.centerPoint)
        
        let node = SKShapeNode(rectOf: smallFrame.size, cornerRadius: config.segmentCornerRadius)
        node.fillColor = segment.color
        node.position = midPoint
        return node
    }
}

extension UIBoard {
    
    func findNode(by segmentPosition : SegmentPosition,
                  in nodes:[SKShapeNode]) -> SKShapeNode? {
        let position = self.midPoint(for: segmentPosition,
                                     relativeTo: config.centerPoint)
        return nodes.filter { $0.frame.contains(position) }.first
    }
}

