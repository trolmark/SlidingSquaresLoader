//
//  UI.swift
//  SnakeProgressIndicator
//
//  Created by Andrew on 6/4/17.
//  Copyright © 2017 app.snake.indicator. All rights reserved.
//

import Foundation
import SpriteKit


struct IndicatorUIConfiguration {
    let animationDuration : CFTimeInterval
    let segmentSideSize : CGFloat
    let segmentPadding : CGFloat
    let segmentCornerRadius : CGFloat
    let centerPoint : CGPoint
}

extension IndicatorUIConfiguration {
    
    func moveStep() -> CGFloat {
        return self.segmentSideSize + self.segmentPadding*2
    }
}


class IndicatorControl : NSObject {
    
    let logic : IndicatorLogic
    let animator : NodeAnimator
    var board : UIBoard
    
    
    
    init(logic:IndicatorLogic,
         configuration:IndicatorUIConfiguration) {
        
        self.logic = logic
        self.board = UIBoard(config: configuration)
        self.animator = NodeAnimator(moveStep: configuration.moveStep(),
                                     duration: configuration.animationDuration)
        super.init()
    }
    
    func run(on scene:SKScene) {
        
        let initState = logic.initialState()
    
        self.board.setupNodes(for: initState.board)
        self.board.nodes.forEach { scene.addChild($0) }
        
        runLoop(for: initState)
    }
}


private extension IndicatorControl {
    
    func runLoop(for state:State) {
       
        let (result, nextState) = self.logic.nextMove(with: state)
        
        guard let moveResult = result
        else { return }
        
        apply(moveResult, to: self.board.nodes) {
            self.runLoop(for: nextState)
        }
    }
    
    
    func apply( _ moveResult : MoveResult, to nodes:[SKShapeNode],
               with completion: @escaping () -> ()) {
        
        let nodesToMove = moveResult.elementsToMove.flatMap {
            self.board.findNode(by: $0.position, in: nodes)
        }
        
        let actions = self.animator.actions(from: moveResult)
        let dispatchGroup = DispatchGroup()
        
        zip(nodesToMove, actions).forEach { node, action in
            dispatchGroup.enter()
            node.run(action) {
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main, execute: completion)
    }
}

