//
//  BgScene.swift
//  testGameSwift
//
//  Created by doo on 6/8/14.
//  Copyright (c) 2014 vortle. All rights reserved.
//

let bgFile: String = "bg.tile.128.png"
let personFileForward: String = "person.move.forward.png"
let personFileLeft: String = "person.move.left.png"
let personFileRight: String = "person.move.right.png"

import SpriteKit


class BgScene: SKScene {
	var xTilesCount: Int = 0
	var yTilesCount: Int = 0
	var tilesArray = SKSpriteNode[]()
	var person: HeroPerson!
	let sceneSize: CGSize = CGSize(width: 960, height: 480)
	var movingLayer: MovingLayer!
	var actionCheckCollision: SKAction?

	override func didMoveToView(view: SKView) {
		/* Setup your scene here */
/*		let myLabel = SKLabelNode(fontNamed:"Chalkduster")
		myLabel.text = "Hello, World!";
		myLabel.fontSize = 65;
		myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
		
		self.addChild(myLabel)*/
		
/*		let xScreenSize = self.frame.size.width
		let yScreenSize = self.frame.size.height
		
		var bgSprite: SKSpriteNode = SKSpriteNode(imageNamed: bgFile)
		
		let xSpriteSize = bgSprite.size.width
		let ySpriteSize = bgSprite.size.height
		
		xTilesCount = Int(xScreenSize/xSpriteSize);
		yTilesCount = Int(yScreenSize/ySpriteSize);
/*
		for var i = 0; i < xTilesCount*yTilesCount; ++i{
			var sprite: SKSpriteNode = SKSpriteNode(imageNamed: "bg")
			tilesArray.append(sprite)
		}
		
*/
		bgSprite.position = CGPointMake(1, 1)
		bgSprite.anchorPoint = CGPointMake(0, 0)
		self.addChild(bgSprite)
*/	
		movingLayer = MovingLayer(bgFile: bgFile, size: sceneSize)
		self.addChild(movingLayer)
		
//		let action = SKAction.moveByX(-128, y: 0, duration: 1.0)
//		movingLayer.runAction(SKAction.repeatActionForever(action))
		movingLayer.startMoving(1.0)
		
		person = HeroPerson(imageForward: personFileForward, imageLeft: personFileLeft, imageRight: personFileRight)
		person.position = CGPoint(x:self.frame.size.width/10, y:CGRectGetMidY(self.frame));
		self.addChild(person)
		person.SetForwardSpeed(15)
		
		person.movingLayer = movingLayer
		
		person.InitCheckCollisions()
	}
	
	override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
		/* Called when a touch begins */
		
		for touch: AnyObject in touches {
			let location = touch.locationInNode(self)
			
			person.MoveToNewLine(location.y.bridgeToObjectiveC().floatValue)
			
//			person.MoveBackward(Float(movingLayer.actionMoveSpeedPixelPerSecond), duration: 1)
			
/*			let sprite = SKSpriteNode(imageNamed:"Spaceship")
			
			sprite.xScale = 0.5
			sprite.yScale = 0.5
			sprite.position = location
			
			let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
			
			sprite.runAction(SKAction.repeatActionForever(action))
			
			self.addChild(sprite)*/
	
		}
	}
	
	override func update(currentTime: CFTimeInterval) {
		/* Called before each frame is rendered */
		
		person.zPosition = (person.position.y - sceneSize.width) * -1
	}
	


}
