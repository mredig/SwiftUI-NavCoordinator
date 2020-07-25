//
//  MockData.swift
//  SwiftUI-NavCoordinator
//
//  Created by Michael Redig on 7/25/20.
//

import Foundation

enum MockData {
	static let listJSON = try! Data(contentsOf: Bundle.main.url(forResource: "list", withExtension: "json")!)
	static let bulbJSON = try! Data(contentsOf: Bundle.main.url(forResource: "bulb", withExtension: "json")!)

	static let bulb: Pokemon = {
		let jsonDec = JSONDecoder()
		jsonDec.keyDecodingStrategy = .convertFromSnakeCase
		return try! jsonDec.decode(Pokemon.self, from: bulbJSON)
	}()
}
