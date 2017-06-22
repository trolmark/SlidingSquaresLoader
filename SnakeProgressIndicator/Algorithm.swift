//
//  Algorithm.swift
//  SnakeProgressIndicator
//
//  Created by Andrew Denisov on 6/14/17.
//  Copyright © 2017 app.snake.indicator. All rights reserved.
//

import Foundation
import UIKit

typealias  HSVColor = (Float, Float, Float)


struct IndicatorAlgorithm {

    fileprivate var pathIterator : PathGenerator
    fileprivate let colorGenerator : ColorGenerator
    let numberOfItems:Int
    
    init(numberOfItems : Int) {
        self.numberOfItems = numberOfItems
        self.pathIterator = PathGenerator(numberOfItems: numberOfItems)
        self.colorGenerator = ColorGenerator()
    }
    
    func generateFigure() -> [Segment] {
        
        let figure = self.generateBoard()
        let elements : [Segment]  = figure.map {
            return Segment(position: $0,
                           color: self.positionToColor($0))
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
    
    func positionToColor(_ position:SegmentPosition) -> UIColor {
        let hsvColor = positionToHsv(position)
        return colorGenerator.hsvToRgb(h: hsvColor.0, s: hsvColor.1, v: hsvColor.2)
    }

    
    func positionToHsv(_ position : SegmentPosition) -> HSVColor {
        let normalizeX = Float(position.x/CGFloat(numberOfItems))
        let normalizeY = Float(position.y/CGFloat(numberOfItems))
        
        return HSVColor(normalizeX, normalizeY, 1.0)
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



struct ColorGenerator {
    
    func hsvToRgb(h:Float, s:Float, v : Float) -> UIColor {
        
        var i = floor(h*6)
        let f = h*6 - i
        let p = v * (1 - s)
        let q = v * (1 - f * s)
        let t = v * (1 - (1 - f) * s)
        
        var rgb : (Float, Float, Float)
        i.formTruncatingRemainder(dividingBy: 6)
        
        switch Int(i) {
        case 0: rgb = (v, t, p)
        case 1 : rgb = (q, v, p)
        case 2: rgb = (p, v, t)
        case 3 :rgb = (p, q, v)
        case 4 : rgb = (t, p, v)
        case 5 : rgb = (v, p, q)
        default : rgb = (v, t, p)
        }
        
        return UIColor(colorLiteralRed: rgb.0 ,
                       green: rgb.1,
                       blue: rgb.2, alpha: 1.0)
    }
}













