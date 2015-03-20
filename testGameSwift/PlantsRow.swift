//
//  PlantsRow.swift
//  testGameSwift
//
//  Created by doo on 6/29/14.
//  Copyright (c) 2014 vortle. All rights reserved.
//

import Foundation

struct PlantsRow{
	let arrayRow: Bool[]
	let count: Int
	
	init(rows:Int){
		count = rows
		arrayRow = Bool[](count: count, repeatedValue: false)
	}
	
	subscript(index: Int) -> Bool {
		get {
			if (index >= 0 && index < arrayRow.count){
				return arrayRow[index]
			}
			else{
				return false
			}
		}
		set(newValue) {
			if (index >= 0 && index < arrayRow.count){
				arrayRow[index] = newValue
			}
		}
	}
}