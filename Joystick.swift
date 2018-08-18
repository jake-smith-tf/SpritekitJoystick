//
//  Joystick.swift
//  A simple SpriteKit Joystick
//  Created by Jake Smith on 03/08/2018.
//  Copyright © 2018 Nebultek. All rights reserved.
//

import Foundation
import SpriteKit

class Joystick: SKNode
{
    var direction:CGVector = CGVector.zero
    let backCircle = SKShapeNode(circleOfRadius: 100)
    let frontCircle = SKShapeNode(circleOfRadius: 50)
    var delegate:JoystickDelegate?
    var active = false
    var lastAngle:CGFloat = 0
    var force:CGFloat = 0
    
    override init() {
        super.init()
        backCircle.position = CGPoint.zero
        backCircle.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.0975731383)
        backCircle.lineWidth = 0
        frontCircle.position = CGPoint.zero
        frontCircle.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        frontCircle.lineWidth = 0
        isUserInteractionEnabled = true
        self.addChild(backCircle)
        self.addChild(frontCircle)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if distance(backCircle.position, (touches.first?.location(in: self))!) > 100
        {
            frontCircle.position = getEdgePos(backCircle.position, (touches.first?.location(in: self))!)
        }
        else
        {
            frontCircle.position = (touches.first?.location(in: self))!
        }
        force = (touches.first?.force)!
        updateDirection()
        updateAngle()
        delegate?.joystickMoved(direction: direction)
    }
    
    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
    }
    
    func updateDirection()
    {
        direction = CGVector(dx: frontCircle.position.x-backCircle.position.x, dy: frontCircle.position.y-backCircle.position.y)
    }
    
    func updateAngle()
    {
        if direction.dx != 0 && direction.dy != 0 {
            if direction.dx > 0
            {
                lastAngle = atan(direction.dy/direction.dx)
            }
            else
            {
                lastAngle = CGFloat.pi + atan(direction.dy/direction.dx)
            }
        }
    }
    
    func getEdgePos(_ a: CGPoint, _ b: CGPoint) -> CGPoint {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        let angle = atan(yDist/xDist)
        let newX = cos(angle)*105
        let newY = sin(angle)*105
        if b.x > a.x {
            return CGPoint(x: newX, y: newY)
        }
        else
        {
            return CGPoint(x: -newX, y: -newY)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if distance(backCircle.position, (touches.first?.location(in: self))!) > 100
        {
            frontCircle.position = getEdgePos(backCircle.position, (touches.first?.location(in: self))!)
        }
        else
        {
            frontCircle.position = (touches.first?.location(in: self))!
        }
        force = (touches.first?.force)!
        updateDirection()
        updateAngle()
        delegate?.joystickMoved(direction: direction)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        frontCircle.run(SKAction.move(to: CGPoint.zero, duration: 0.05))
        direction = CGVector.zero
        force = 1
        delegate?.joystickMoved(direction: direction)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

protocol JoystickDelegate: class {
    func joystickMoved(direction: CGVector)
}
