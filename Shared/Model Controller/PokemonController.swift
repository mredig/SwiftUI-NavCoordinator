//
//  Pokemons.swift
//  SwiftUI-NavCoordinator
//
//  Created by Michael Redig on 7/25/20.
//

import Foundation
import NetworkHandler

class PokemonController: ObservableObject {
	@Published private(set) var pokemonList: [PokemonResult] = []
	@Published private(set) var cachedPokemon: [Int: Pokemon] = [:]

	static let baseURL = URL(string: "https://pokeapi.co/api/v2/")!

	init() {
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		NetworkRequest.defaultDecoder = decoder
	}

	func loadPokemonList(completion: ((PokemonResult.ListResult) -> Void)? = nil) {
		let url = Self.baseURL.appendingPathComponent("pokemon")
		var components = URLComponents(url: url, resolvingAgainstBaseURL: true)

		let queryItems = [
			URLQueryItem(name: "offset", value: "0"),
			URLQueryItem(name: "limit", value: "1000")
		]
		components?.queryItems = queryItems
		guard let finalURL = components?.url else { return }
		var request = finalURL.request

		request.addValue(.contentType(type: .json), forHTTPHeaderField: .commonKey(key: .contentType))

		NetworkHandler.default.transferMahCodableDatas(with: request) { (results: Result<PokemonPagingResult, NetworkError>) in
			let saveLocal = results.flatMap { pagingResult -> Result<[PokemonResult], NetworkError> in
				let pokemons = pagingResult.results
				self.pokemonList = pokemons
				return .success(pokemons)
			}
			.flatMapError { error -> PokemonResult.ListResult in
				.failure(error)
			}
			completion?(saveLocal)
		}
	}

}
