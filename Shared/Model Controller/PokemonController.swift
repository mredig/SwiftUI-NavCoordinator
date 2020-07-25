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

	private let networkLoader: NetworkLoader

	init(networkLoader: NetworkLoader = URLSession.shared) {
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		NetworkRequest.defaultDecoder = decoder

		self.networkLoader = networkLoader
	}

	@discardableResult func genericNetworkingRequest<ResultType: Decodable>(request: NetworkRequest,
																			usingCache: Bool = false,
																			completion: @escaping (Result<ResultType, Error>) -> Void) -> NetworkLoadingTask? {
		NetworkHandler.default.transferMahCodableDatas(
			with: request,
			usingCache: usingCache,
			session: networkLoader) { (result: Result<ResultType, NetworkError>) in
			// use flatmap to cast NetworkError as Error, then just run expected completion as normal
			completion(result.flatMapError({ .failure($0) }))
		}
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

		genericNetworkingRequest(request: request) { (results: Result<PokemonPagingResult, Error>) in
			let saveLocal = results.flatMap { pagingResult -> PokemonResult.ListResult in
				let pokemons = pagingResult.results
				DispatchQueue.main.async {
					self.pokemonList = pokemons
				}
				return .success(pokemons)
			}
			completion?(saveLocal)
		}
	}

	func loadPokemon(from pokemonResult: PokemonResult, completion: ((Pokemon.SingleResult) -> Void)? = nil) {
		var request = pokemonResult.url.request
		request.addValue(.contentType(type: .json), forHTTPHeaderField: .commonKey(key: .contentType))

		if let cached = cachedPokemon[pokemonResult.id] {
			DispatchQueue.main.async {
				completion?(.success(cached))
			}
			return
		}

		genericNetworkingRequest(request: request) { (results: Pokemon.SingleResult) in
			let saveLocal = results.flatMap { pokemon -> Pokemon.SingleResult in
				DispatchQueue.main.async {
					self.cachedPokemon[pokemon.id] = pokemon
				}
				return .success(pokemon)
			}
			completion?(saveLocal)
		}
	}
}
