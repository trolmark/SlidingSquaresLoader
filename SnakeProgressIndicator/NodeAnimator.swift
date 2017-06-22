//
//  UIAnimator.swift
//  SnakeProgressIndicator
//
//  Created by Andrew Denisov on 6/22/17.
//  Copyright © 2017 app.snake.indicator. All rights reserved.
//

import Foundation
import SpriteKit


struct NodeAnimator {
    
    let moveStep : CGFloat
    let duration : CFTimeInterval
    
    func action(for move:SegmentMove) -> SKAction {
        switch move {
        case .down:
            return SKAction.moveBy(x: 0, y: -moveStep,
                                   duration: duration)
        case .left:
            return SKAction.moveBy(x: -moveStep, y: 0,
                                   duration: duration)
        case .right:
            return SKAction.moveBy(x: moveStep, y: 0,
                                   duration: duration)
        case .up:
            return SKAction.moveBy(x: 0, y: moveStep,
                                   duration: duration)
        }
    }
    
    func action(for color:UIColor) -> SKAction {
        
        return SKAction.customAction(withDuration: duration) { node, elapsedTime in
            let shapeNode = node as! SKShapeNode
            shapeNode.fillColor = color
        }
    }
    
    func actions(from result:MoveResult) -> [SKAction] {
        
        let move = result.move
        let moveAction = self.action(for: move)
        
        return result.elementsToMove.map { element in
            let colorAction = self.action(for: element.color)
            return SKAction.group([moveAction,colorAction])
        }
    }
}
