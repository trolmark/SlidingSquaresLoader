//
//  Domain.swift
//  SnakeProgressIndicator
//
//  Created by Andrew on 6/4/17.
//  Copyright © 2017 app.snake.indicator. All rights reserved.
//

import Foundation
import UIKit



enum SegmentMove {
    case left
    case right
    case down
    case up
}

enum Direction {
    case horizontal
    case vertical
}

typealias SegmentPosition = CGPoint

struct Segment {
    let position : SegmentPosition
    var color : UIColor
}

struct State {
    let activeSegment : Segment
    let move : SegmentMove?
    let board : [Segment]
}

struct MoveResult {
    let elementsToMove : [Segment]
    let move : SegmentMove
}



protocol OppositeValueProtocol {
    associatedtype Element
    func opposite() -> Element
}


extension Segment {
    
    func apply(move:SegmentMove) -> Segment {
        let newPosition = position.apply(move: move)
        return Segment(position: newPosition,
                       color: self.color)
    }
}

extension SegmentPosition {
    
    func apply(move:SegmentMove) -> SegmentPosition {
        switch move {
        case .down:
            return SegmentPosition(x: self.x, y: self.y - 1)
        case .left:
            return SegmentPosition(x: self.x - 1, y: self.y)
        case .right:
            return SegmentPosition(x: self.x + 1, y: self.y)
        case .up:
            return SegmentPosition(x: self.x, y: self.y + 1)
        }
    }
}


extension SegmentMove : OppositeValueProtocol {
    
    func opposite() -> SegmentMove {
        switch self {
        case .left: return .right
        case .right : return .left
        case .up : return .down
        case .down : return .up
        }
    }
}


extension Direction : OppositeValueProtocol {
    
    func opposite() -> Direction {
        switch self {
        case .horizontal: return .vertical
        case .vertical : return .horizontal
        }
    }
}

func == (lhs: Segment, rhs:Segment ) -> Bool {
    return lhs.position == rhs.position
}
