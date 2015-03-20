//
//  MovingLayer.swift
//  testGameSwift
//
//  Created by doo on 6/10/14.
//  Copyright (c) 2014 vortle. All rights reserved.
//

let plantsFileName = "plants.6x3.png"
let plantsRows = 5

import SpriteKit


class MovingLayer: SKNode {

	class MovingRow: SKNode {
		var xSize: CGFloat
		var yCount: Int
		var yBgSpriteOffset: Int = 0
		init(bgFile: String, height: CGFloat) {
			var bg = SKSpriteNode(imageNamed: bgFile)
			let bgSpriteSize = bg.size
			let bgSpriteHeightHalf = Int(bgSpriteSize.height) / 2
			xSize = bgSpriteSize.width
			yCount = Int(height / bgSpriteSize.height)
			var yRemainder = height % bgSpriteSize.height
			if yRemainder > 0 {
				yBgSpriteOffset = Int(yRemainder/2)
				++yCount;
			}
			super.init()
			bg.anchorPoint = CGPointMake(0.5, 0.5)
			bg.position = CGPointMake(0, CGFloat(yBgSpriteOffset - bgSpriteHeightHalf))
			self.addChild(bg)
			for i in 0..yCount {
				var bgSprite = SKSpriteNode(imageNamed: bgFile)
				bgSprite.anchorPoint = CGPointMake(0.5, 0.5)
				bgSprite.position = CGPointMake(0, CGFloat(yBgSpriteOffset + bgSpriteHeightHalf*i*2))
				self.addChild(bgSprite)
			}
		}
	}
	
	
	var bgFile: String
	var size: CGSize
	var xCount: Int
	var yCount: Int
	var xBgSpriteOffset: Int = 0
	var yBgSpriteOffset: Int = 0
	
	var rowArray: MovingRow[] = []
	var rowWidth: CGFloat
	
	var actionMove: SKAction?

	var actionMovingSpeed: Double = 0
	var actionMoveSpeedPixelPerSecond: Double = 0
	
	var rowCountLast: Int = 0

	var arrayPlants: PlantsSprite[] = []
	
	var plantsSequence: PlantsSequence
	
	init(bgFile: String, size: CGSize) {
		self.bgFile = bgFile
		self.size = size
		let bg = SKSpriteNode(imageNamed: bgFile)
		rowWidth = bg.size.width
		xCount = Int(size.width / bg.size.width)
		yCount = Int(size.height / bg.size.height)
		var xRemainder = size.width % bg.size.width
		var yRemainder = size.height % bg.size.height
		if xRemainder > 0 {
			xBgSpriteOffset = Int(xRemainder/2)
			++xCount;
		}
		if yRemainder > 0 {
			yBgSpriteOffset = Int(yRemainder/2)
			++yCount
		}
		
		plantsSequence = PlantsSequence(columns: xCount, rows: yCount)
		
		super.init()
		
		
		for i in 0...xCount {
			let row = MovingRow(bgFile: bgFile, height: size.height)
			let x = bg.size.width * CGFloat(i) + bg.size.width/2.0
			row.position = CGPointMake(x , 0)
			rowArray.append(row)
			self.addChild(row)
		}

	}
	
	func fnRestartMove() {
		var rowPos: CGPoint = rowArray[rowCountLast].position
		rowPos.x += rowWidth * CGFloat(rowArray.count)
		rowArray[rowCountLast].position = rowPos
		rowCountLast++
		if rowCountLast >= rowArray.count{
			rowCountLast -= rowArray.count
		}
		RemovePlants()
		AppendPlants()
		restartMoving()
	}
	
	func startMoving(speed: Double){
		stopMoving()
		actionMovingSpeed = speed
		if actionMovingSpeed != 0 {
			actionMoveSpeedPixelPerSecond = Double(self.rowWidth)/speed
			restartMoving()
		}
	}
	
	func restartMoving(){
		actionMove = SKAction.moveToX(self.position.x-self.rowWidth, duration: actionMovingSpeed)
		self.runAction(actionMove, completion: fnRestartMove)
	}
	
	func stopMoving(){
		self.removeAllActions()
	}
	
	func AppendPlants(){
		var maxPlantsInColumn = random() % (yCount - 1)
		var minPlantsInColumn = 0
		if maxPlantsInColumn > 1 {
			minPlantsInColumn = random() % (maxPlantsInColumn-1)
		}
		
		var plantsRow = plantsSequence.NextRow(minPlantsInColumn, plantsMax: maxPlantsInColumn)
		if (plantsRow == nil){
//			NSLog("PlantsRow == nil\nminPlantsInColumn=%1i\nmaxPlantsInColumn=%1i\n",minPlantsInColumn,maxPlantsInColumn)
			return
		}
		else{
//			NSLog("\nminPlantsInColumn=%1i\nmaxPlantsInColumn=%1i\n",minPlantsInColumn,maxPlantsInColumn)

			let rowPos: CGPoint = rowArray[rowCountLast].position
			for i in 0..plantsRow.count {
				if plantsRow[i] {
//					NSLog("Plant in position: %1i\n", i)
					let plantPos: CGPoint = CGPoint(x: rowPos.x + size.width, y: (CGFloat(i) + 0.5) * size.height / CGFloat(plantsRows))
					let plantsObject = PlantsSprite(imageNamed: plantsFileName)
					plantsObject.position = plantPos
					plantsObject.zPosition = (plantPos.y - size.width) * -1
					arrayPlants.append(plantsObject)
					self.addChild(plantsObject)
				}
			}
		}
	}

	
	func RemovePlants(){
		let rowPos: CGPoint = rowArray[rowCountLast].position
		for var i = 0; i < arrayPlants.count; ++i {
			var plant: PlantsSprite = arrayPlants[i]
			if (plant.position.x < rowPos.x - 150){
				plant.removeFromParent()
				arrayPlants.removeAtIndex(i)
			}
			else{
				break
			}
		}
	}
}
