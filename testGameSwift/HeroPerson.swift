//
//  HeroPerson.swift
//  testGameSwift
//
//  Created by doo on 6/22/14.
//  Copyright (c) 2014 vortle. All rights reserved.
//

let shiftSpeed: Double = 60		//pixels/sec

let personRectSize: CGFloat = 32

import SpriteKit

class HeroPerson: SKNode {
	let personForward: MovingPerson
	let personLeft: MovingPerson
	let personRight: MovingPerson
	var speedForward: Float = 0
	var actionForward: SKAction?
	let actionForwardKey = "ActionFwd"
	var isBackRunning = false
	weak var movingLayer: MovingLayer!
	
	var actionCollisions: SKAction?
	
	init(imageForward fileForward: String, imageLeft fileLeft: String, imageRight fileRight: String){
		personForward = MovingPerson(imageNamed: fileForward)
		personLeft = MovingPerson(imageNamed: fileLeft)
		personRight = MovingPerson(imageNamed: fileRight)
		super.init()
		personLeft.hidden = true
		personRight.hidden = true
		self.addChild(personLeft)
		self.addChild(personRight)
		self.addChild(personForward)
		personForward.StartAnimation()
	}
	
	func SetForwardSpeed(speed: Float){ //speed - pixel per second
		speedForward = speed
		if (actionForward != nil){
			self.removeActionForKey(actionForwardKey)
		}
		if !isBackRunning {
			if  speed != 0 {
				var action = SKAction.moveByX(CGFloat(speed), y: 0, duration: 1)
				actionForward = SKAction.repeatActionForever(action)
				self.runAction(actionForward, withKey: actionForwardKey)
			}
		}
	}
	
	func MoveBackward(speed: Float, duration: Double){
		if isBackRunning {
			return
		}
		if  actionForward != nil {
			self.removeActionForKey(actionForwardKey)
		}
		if  speed != 0 {
			isBackRunning = true
			var actionBack = SKAction.moveByX(CGFloat(-speed), y: 0, duration: duration)
			self.runAction(actionBack, completion: RestartMoveForward)
		}
		
	}
	
	func RestartMoveForward(){
		isBackRunning = false
		if speedForward != 0 {
			var action = SKAction.moveByX(CGFloat(speedForward), y: 0, duration: 1)
			actionForward = SKAction.repeatActionForever(action)
			self.runAction(actionForward, withKey: actionForwardKey)
		}
	}
	
	func RestoreMoveForward(){
		personLeft.hidden = true
		personRight.hidden = true
		personForward.hidden = false
		personLeft.StopAnimation()
		personRight.StopAnimation()
		personForward.StartAnimation()
		
	}
	
	func MoveToNewLine(y: Float){
		let currentY = Float(self.position.y)
		if (currentY != y){
//			self.removeAllActions()
			personLeft.StopAnimation()
			personRight.StopAnimation()
			personForward.StopAnimation()
			let bLeft = currentY < y ? true : false
			var yDist = bLeft ? y - currentY : currentY - y
			if bLeft {
				personLeft.hidden = false
				personRight.hidden = true
				personForward.hidden = true
				personLeft.StartAnimation()
				personRight.StopAnimation()
				personForward.StopAnimation()
			}
			else {
				personLeft.hidden = true
				personRight.hidden = false
				personForward.hidden = true
				personLeft.StopAnimation()
				personRight.StartAnimation()
				personForward.StopAnimation()
			}
			let action = SKAction.moveToY(CGFloat(y), duration: Double(yDist)/shiftSpeed)
			self.runAction(action, completion: RestoreMoveForward)
		}
	}
	
	func InitCheckCollisions(){
		let action1 = SKAction.waitForDuration(0.5)
		let action2 = SKAction.runBlock(CheckCollision)
		let action3 = SKAction.sequence([action1, action2])
		actionCollisions = SKAction.repeatActionForever(action3)
		self.runAction(actionCollisions)
	}
	
	func GetPointDistance(point1: CGPoint, point2: CGPoint) -> CGFloat {
		var fx = point1.x - point2.x
		var fy = point1.y - point2.y
		return CGFloat(sqrt(fx*fx + fy*fy))
	}
	
	func CheckCollision(){
		var personPos = self.position
		personPos.x -= movingLayer.position.x
		
		for plant in movingLayer.arrayPlants {
			let plantPos = plant.position
			if GetPointDistance(personPos, point2: plantPos) < personRectSize
			{
				plant.alpha = 0.5
				self.MoveBackward(Float(movingLayer.actionMoveSpeedPixelPerSecond), duration: 1.0)
				break
			}
		}
	}
	
}