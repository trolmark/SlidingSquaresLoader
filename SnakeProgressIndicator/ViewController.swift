//
//  ViewController.swift
//  SnakeProgressIndicator
//
//  Created by Andrew on 6/4/17.
//  Copyright © 2017 app.snake.indicator. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {
    
    fileprivate var control : IndicatorControl?
    fileprivate var scene : SKScene?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        let frame = self.view.bounds
        self.scene = SKScene(size: frame.size)
        
        let container = SKView(frame:  frame)
        container.presentScene(scene)
        
        self.view.addSubview(container)
    
        self.control = self.makeIndicator(withCenter: CGPoint(x: self.view.center.x - 50,
                                                              y: self.view.center.y))
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        guard let activeScene = self.scene,
            let indicator = self.control
        else { return }

        indicator.run(on: activeScene)
    }

    
    func makeIndicator(withCenter:CGPoint) -> IndicatorControl {
        
        let algorithm = IndicatorAlgorithm(numberOfItems: 6)
        let logic = IndicatorLogic(with: algorithm)
        
        let config = IndicatorUIConfiguration(animationDuration: 0.2,
                                              segmentSideSize: 20,
                                              segmentPadding: 2.0,
                                              segmentCornerRadius: 2.0,
                                              centerPoint: withCenter)
        
        return IndicatorControl(logic: logic, configuration: config)
    }


}

