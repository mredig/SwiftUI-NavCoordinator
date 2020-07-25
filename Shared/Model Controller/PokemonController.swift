//
//  Pokemons.swift
//  SwiftUI-NavCoordinator
//
//  Created by Michael Redig on 7/25/20.
//

import Foundation
import NetworkHandler

class PokemonController: ObservableObject {
	@Published private(set) var localPokemon: [Pokemon] = []

	static let baseURL = URL(string: "https://pokeapi.co/api/v2/")!

	init() {
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		NetworkRequest.defaultDecoder = decoder
	}

	func loadPokemon(completion: ((Pokemon.ListResult) -> Void)? = nil) {
		let url = Self.baseURL.appendingPathComponent("pokemon")
		var components = URLComponents(url: url, resolvingAgainstBaseURL: true)

		let queryItems = [
			URLQueryItem(name: "offset", value: "0"),
			URLQueryItem(name: "limit", value: "100")
		]
		components?.queryItems = queryItems
		guard let finalURL = components?.url else { return }
		var request = finalURL.request

		request.addValue(.contentType(type: .json), forHTTPHeaderField: .commonKey(key: .contentType))

		NetworkHandler.default.transferMahCodableDatas(with: request) { (results: Result<[Pokemon], NetworkError>) in
			let saveLocal = results.flatMap { pokemons -> Result<[Pokemon], NetworkError> in
				self.localPokemon = pokemons
				return .success(pokemons)
			}
			.flatMapError { error -> Result<[Pokemon], Error> in
				.failure(error)
			}
			completion?(saveLocal)
		}
	}

}
