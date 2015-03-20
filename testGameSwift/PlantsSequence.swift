//
//  PlantsSequence.swift
//  testGameSwift
//
//  Created by doo on 6/26/14.
//  Copyright (c) 2014 vortle. All rights reserved.
//

//let plantsCountInRow = 5
//let plantsRowCount = 3

import Foundation

class PlantsSequence {
	
	var plantsRow: PlantsRow[]
	let count: Int
	let rows: Int
	init(columns: Int, rows: Int){
		count = columns
		self.rows = rows
		plantsRow = PlantsRow[](count: count, repeatedValue: PlantsRow(rows: rows))
	}

	subscript(index: Int) -> PlantsRow {
		get {
			if (index >= 0 && index < count){
				return plantsRow[index]
			}
			else{
				return PlantsRow(rows: rows)
			}
		}
	}

	func CheckPossibleCell(index: Int, array: Dictionary<Int, Bool>) -> Bool {
		if index >= 0 && index < rows {
			if array[index] != nil {
				return array[index].getLogicValue()
			}
		}
		return false
	}
	
	func NextRow(var plantsMin: Int, var plantsMax: Int) -> PlantsRow {
		var newColumn = PlantsRow(rows: rows)
		if (plantsMax <= 0){
			plantsRow += newColumn
			plantsRow.removeAtIndex(0)
			return plantsRow[count-1]
		}
		
		if plantsMin<0{
			plantsMin = 0
		}
		if (plantsMax > rows){
			plantsMax = rows
		}
		if (plantsMin > plantsMax){
			plantsMin = plantsMax
		}
		
		var possibleWayCells = Dictionary<Int, Bool>()
		for i in 0..rows{
			possibleWayCells[i] = false
		}
		for i in 0..rows{
			if !plantsRow[count-1][i]{
				possibleWayCells[i] = true
				if (i>=1){
					possibleWayCells[i-1] = true
				}
				if (i<rows-1){
					possibleWayCells[i+1] = true
				}
			}
		}
		var plantsCellProhibited = Dictionary<Int, Bool>()
		for i in 0..rows{
			plantsCellProhibited[i] = false
		}
		var plantsSuggested = (random() % (plantsMax-plantsMin)) + plantsMin
		for _ in 0...plantsSuggested {
			var foundFreeCell = false
			var index = random() % rows
			var isCellOpen: Bool = plantsCellProhibited[index]!
			if isCellOpen {
				for _ in 0...100 {
					index = random() % rows
					isCellOpen = plantsCellProhibited[index]!
					if  isCellOpen {
						continue
					}
					if CheckPossibleCell(index, array: possibleWayCells) {
						foundFreeCell = true
						plantsCellProhibited[index] = true
						newColumn[index] = true
						break
					}
				}
			}
			else{
				if CheckPossibleCell(index, array: possibleWayCells) {
					foundFreeCell = true
					plantsCellProhibited[index] = true
					newColumn[index] = true
				}
			}
			if !foundFreeCell {
				var oldIndex = index
				index++
				for _ in 0..rows {
					if index >= rows {
						index -= rows
					}
					if (index == oldIndex) {
						break
					}
					isCellOpen = plantsCellProhibited[index]!
					if isCellOpen {
						continue
					}
					if CheckPossibleCell(index, array: possibleWayCells) {
						foundFreeCell = true
						plantsCellProhibited[index] = true
						newColumn[index] = true
						break
					}
				}
			}
		}
		plantsRow += newColumn
		plantsRow.removeAtIndex(0)
		return plantsRow[count-1]
	}
}
