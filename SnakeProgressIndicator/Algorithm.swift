//
//  Algorithm.swift
//  SnakeProgressIndicator
//
//  Created by Andrew Denisov on 6/14/17.
//  Copyright © 2017 app.snake.indicator. All rights reserved.
//

import Foundation
import UIKit




struct IndicatorAlgorithm {

    fileprivate var pathIterator : PathGenerator
    let numberOfItems:Int
    
    init(numberOfItems : Int) {
        self.numberOfItems = numberOfItems
        self.pathIterator = PathGenerator(numberOfItems: numberOfItems)
    }
    
    func generateFigure() -> [Segment] {
        
        let figure = self.generateBoard()
        let elements : [Segment]  = figure.map {
            return Segment(position: $0,
                           color: self.color(for: $0))
        }
        return elements
    }
    
    func generateBoard() -> [SegmentPosition] {
        var figure : [SegmentPosition] = []
        var countdown = 0
        let yCoord = 1
        
        let startSegment = SegmentPosition(x: countdown, y: yCoord + 1)
        figure.append(startSegment)
        
        while countdown < numberOfItems {
            let position = SegmentPosition(x: countdown, y: yCoord)
            figure.append(position)
            countdown = countdown + 1
        }
        
        return figure
    }
    
    mutating func nextMove() -> SegmentMove? {
        return self.pathIterator.next()
    }
    
    func color(for position:SegmentPosition) -> UIColor {
        return .blue
    }
}


struct PathGenerator : IteratorProtocol {
    
    typealias Element = SegmentMove
    
    let numberOfItems : Int
    var stepIndex : Int
    
    var nextVerticalMove: SegmentMove
    var nextHorizontalMove : SegmentMove
    var direction : Direction
    
    
    init(numberOfItems:Int) {
        self.numberOfItems = numberOfItems
        self.stepIndex = 1
        
        self.nextVerticalMove = .down
        self.nextHorizontalMove = .right
        
        self.direction = .vertical
    }
    
    mutating func next() -> SegmentMove? {
        
        if self.needGoBackward() {
            stepIndex = 1
            self.nextHorizontalMove = self.nextHorizontalMove.opposite()
        }
        
        var nextMove : SegmentMove
        
        switch self.direction {
        case .vertical:
            nextMove = self.nextVerticalMove
            self.nextVerticalMove = self.nextVerticalMove.opposite()
            
        case .horizontal :
            nextMove = self.nextHorizontalMove
        }
        
        self.direction = self.direction.opposite()
        stepIndex = stepIndex + 1
        
        return nextMove
    }
    
    private func needGoBackward() -> Bool {
        return stepIndex == (2*numberOfItems - 1)
    }
}













