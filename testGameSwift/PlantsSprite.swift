//
//  PlantsSprite.swift
//  testGameSwift
//
//  Created by doo on 6/22/14.
//  Copyright (c) 2014 vortle. All rights reserved.
//

let plantTextureX:Int = 6
let plantTextureY:Int = 3
let plantTextureSizeX: CGFloat = 1.0/CGFloat(plantTextureX)
let plantTextureSizeY: CGFloat = 1.0/CGFloat(plantTextureY)
let plantAnchorPointPos = CGPoint(x: 0.5, y: 0.15)
let plantScale: CGFloat = 0.75

import SpriteKit

class PlantsSprite: SKSpriteNode {
	var arrayTextures: SKTexture[] = []
	
	init(imageNamed name: String!) {
		let textureBig = SKTexture(imageNamed: name)
		let textureSize = CGSize(width: plantTextureSizeX, height: plantTextureSizeY)
		var rect:CGRect = CGRect(x: 0.0, y: 0.0, width: plantTextureSizeX, height: plantTextureSizeY)
		var arrayTexturesInit: SKTexture[] = []
		for i in (0 .. plantTextureX*plantTextureY) {
			var xVar: Int = i % textureX
			var yVar: Int = i/textureX
			var rect:CGRect = CGRect(x: CGFloat(xVar)*plantTextureSizeX, y: CGFloat(yVar)*plantTextureSizeY, width: plantTextureSizeX, height: plantTextureSizeY)
			let textureFrame = SKTexture(rect: rect, inTexture: textureBig)
			arrayTexturesInit.append(textureFrame)
			//			NSLog("x: %1i, y: %1i", xVar, yVar)
		}
		super.init(texture: arrayTexturesInit[0])
		arrayTextures = arrayTexturesInit
		//		NSLog("array size final: %1i", arrayTextures.count)
		self.xScale = plantScale
		self.yScale = plantScale
		self.anchorPoint = plantAnchorPointPos
		SetRandomPlant()
	}

	init(texture: SKTexture!, color: UIColor!, size: CGSize) {
		super.init(texture: texture, color: color, size: size)
	}
	
	func SetRandomPlant(){
		let arrayLen = arrayTextures.count
		let randomIndex = random() % arrayLen
		self.texture = arrayTextures[randomIndex]
	}

}

