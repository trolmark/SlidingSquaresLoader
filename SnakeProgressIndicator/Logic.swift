//
//  LogicImplementation.swift
//  SnakeProgressIndicator
//
//  Created by Andrew on 6/4/17.
//  Copyright © 2017 app.snake.indicator. All rights reserved.
//

import Foundation
import UIKit



class IndicatorLogic {
    
    var algorithm : IndicatorAlgorithm
    
    init(with algorithm : IndicatorAlgorithm) {
        self.algorithm = algorithm
    }

    func initialState() -> State {
        
        let figure = self.algorithm.generateFigure()
        let start = figure.first!
        let startMove = self.algorithm.nextMove()
        
        return State(activeSegment: start,
                     move: startMove,
                     board: figure)
    }
        
    func nextMove(with state:State) -> (MoveResult?,State) {
                
        guard let move = state.move
        else { return (nil, state) }
        
        let (shiftedSegments, nextActive) = segmentsToShift(from: state.board,
                                                            with: state.activeSegment,
                                                            move: move,
                                                            accumulator: [state.activeSegment])

        let newBoard = self.shift(segmentsToShift: shiftedSegments,
                                  with: move,
                                  on: state.board)
        
        let moveResult = MoveResult(elementsToMove: shiftedSegments, move: move)
        let newState = State(activeSegment: nextActive,
                             move: self.algorithm.nextMove(),
                             board: newBoard)
    
        return (moveResult, newState)
    }
}

private extension IndicatorLogic {
    
    func shift(segmentsToShift:[Segment],
               with move:SegmentMove,
               on board:[Segment]) -> [Segment] {
        
        return board.map { segmentInBoard -> Segment in
            if segmentsToShift.contains(where: { $0 == segmentInBoard }) {
                return segmentInBoard.apply(move: move,
                                            position2Color: self.algorithm.positionToColor)
            }
            return segmentInBoard
        }
    }
    

    func segmentsToShift(from segments:[Segment],
                         with start : Segment,
                         move:SegmentMove,
                         accumulator:[Segment]) -> ([Segment], Segment) {
    
        let nextCoordinate = start.position.apply(move: move)
        guard let neighbor = segments.first(where: { $0.position == nextCoordinate })
        else {
            return (accumulator, Segment(position: nextCoordinate,
                                         color: start.color))
        }

        return self.segmentsToShift(from:segments,
                                    with:neighbor,
                                    move:move,
                                    accumulator:accumulator + [neighbor])
    }
}

