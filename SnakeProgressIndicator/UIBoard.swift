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


// Nodes
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

// Actions
extension UIBoard {
    
    func action(for move:SegmentMove) -> SKAction {
        switch move {
        case .down:
            return SKAction.moveBy(x: 0, y: -config.moveStep(),
                                   duration: config.animationDuration)
        case .left:
            return SKAction.moveBy(x: -config.moveStep(), y: 0,
                                   duration: config.animationDuration)
        case .right:
            return SKAction.moveBy(x: config.moveStep(), y: 0,
                                   duration: config.animationDuration)
        case .up:
            return SKAction.moveBy(x: 0, y: config.moveStep(),
                                   duration: config.animationDuration)
        }
    }
    
    func action(for color:UIColor) -> SKAction {
        return SKAction.customAction(withDuration: config.animationDuration) { node, elapsedTime in
            let shapeNode = node as! SKShapeNode
            shapeNode.fillColor = color
        }
    }
}

// Helpers
extension UIBoard {
    
    func actions(from result:MoveResult) -> [SKAction] {
        
        let move = result.move
        let moveAction = self.action(for: move)
        
        return result.elementsToMove.map { element in
            let colorAction = self.action(for: element.color)
            return SKAction.group([moveAction,colorAction])
        }
    }
    
    func findNode(by segmentPosition : SegmentPosition,
                  in nodes:[SKShapeNode]) -> SKShapeNode? {
        let position = self.midPoint(for: segmentPosition,
                                     relativeTo: config.centerPoint)
        return nodes.filter { $0.frame.contains(position) }.first
    }
}

