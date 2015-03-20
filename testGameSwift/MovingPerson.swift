//
//  MovingPerson.swift
//  testGameSwift
//
//  Created by doo on 6/17/14.
//  Copyright (c) 2014 vortle. All rights reserved.
//

let textureX:Int = 4
let textureY:Int = 2
let textureSizeX: CGFloat = 1.0/CGFloat(textureX)
let textureSizeY: CGFloat = 1.0/CGFloat(textureY)
let anchorPointPos = CGPoint(x: 0.5, y: 0.25)
let animateSpeed: Double = 20.0

import SpriteKit

class MovingPerson: SKSpriteNode {
	var arrayTextures: SKTexture[] = []
	var animate: SKAction!
	let animateKey = "animateActionKey"
	
	init(imageNamed name: String!) {
		let textureBig = SKTexture(imageNamed: name)
		let textureSize = CGSize(width: textureSizeX, height: textureSizeY)
		var rect:CGRect = CGRect(x: 0.0, y: 0.0, width: textureSizeX, height: textureSizeY)
		var arrayTexturesInit: SKTexture[] = []
		for i in (0 .. textureX*textureY) {
			var xVar: Int = i % textureX
			var yVar: Int = i/textureX
			var rect:CGRect = CGRect(x: CGFloat(xVar)*textureSizeX, y: CGFloat(yVar)*textureSizeY, width: textureSizeX, height: textureSizeY)
			let textureFrame = SKTexture(rect: rect, inTexture: textureBig)
			arrayTexturesInit.append(textureFrame)
//			NSLog("x: %1i, y: %1i", xVar, yVar)
		}
		super.init(texture: arrayTexturesInit[0])
		arrayTextures = arrayTexturesInit
//		NSLog("array size final: %1i", arrayTextures.count)
		
		self.anchorPoint = anchorPointPos
		
		let action = SKAction.repeatActionForever(SKAction.animateWithTextures(arrayTextures, timePerFrame: 1.0/animateSpeed))
		animate = action
		
	}
	
	init(texture: SKTexture!, color: UIColor!, size: CGSize) {
		super.init(texture: texture, color: color, size: size)
	}
	
	func StartAnimation() {
		self.runAction(animate, withKey: animateKey)
	}
	
	func StopAnimation() {
		self.removeActionForKey(animateKey)
	}
	
	
}
