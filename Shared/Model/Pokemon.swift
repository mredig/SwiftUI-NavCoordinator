//
//  Pokemon.swift
//  SwiftUI-NavCoordinator
//
//  Created by Michael Redig on 7/25/20.
//

import Foundation

struct PokemonPagingResult: Codable {
	typealias ListResult = Result<[Self], Error>
	typealias SingleResult = Result<Self, Error>

	let count: Int
	let next: URL?
	let previous: URL?

	let results: [PokemonResult]
}

struct PokemonResult: Codable, Identifiable {
	typealias ListResult = Result<[Self], Error>
	typealias SingleResult = Result<Self, Error>

	var id: Int {
		Int(self.url.lastPathComponent)!
	}
	let name: String
	let url: URL
}

struct Pokemon: Codable {
	typealias ListResult = Result<[Pokemon], Error>
	typealias SingleResult = Result<Pokemon, Error>

	let id: Int
	let name: String
	let baseExperience: Int
	let order: Int
	let moves: [PokemonMoveContainer]
	let sprites: PokemonSprites
	let stats: [PokemonStatContainer]
}

struct PokemonMoveContainer: Codable {
	let move: PokemonMove
}

struct PokemonMove: Codable {
	let name: String
	let url: URL
}

struct PokemonSprites: Codable {
	let backFemale: URL?
	let backShinyFemale: URL?
	let backDefault: URL?
	let frontFemale: URL?
	let frontShinyFemale: URL?
	let backShiny: URL?
	let frontDefault: URL?
	let frontShiny: URL?
}

struct PokemonStatContainer: Codable {
	let stat: PokemonStat
	let effort: Int
	let baseStat: Int
}

struct PokemonStat: Codable {
	let id: Int?
	let name: String
	let gameIndex: Int?
	let isBattleOnly: Bool?
}
