//
//  PokemonDetail.swift
//  SwiftUI-NavCoordinator
//
//  Created by Michael Redig on 7/25/20.
//

import SwiftUI

protocol PokemonDetailNavCoordinator: PokemonControllerContainingNavCoordinator {}

struct PokemonDetail: View {
	let pokemonResult: PokemonResult
	let pokemon: Pokemon?
	let detailCoordinator: PokemonDetailNavCoordinator
	@ObservedObject var pokemonController: PokemonController

	fileprivate init(pokemonResult: PokemonResult, detailCoordinator: PokemonDetailNavCoordinator, testPokemon: Pokemon? = nil) {
		self.detailCoordinator = detailCoordinator
		self.pokemonResult = pokemonResult
		self.pokemonController = detailCoordinator.pokemonController
		self.pokemon = testPokemon ?? detailCoordinator.pokemonController.cachedPokemon[pokemonResult.id]
	}

	init(pokemonResult: PokemonResult, detailCoordinator: PokemonDetailNavCoordinator) {
		self.init(pokemonResult: pokemonResult, detailCoordinator: detailCoordinator, testPokemon: nil)
	}

	var body: some View {
		if let pokemon = pokemon {
			HStack {
				Text(pokemon.name)
				Text("\(pokemon.id)")
			}
		} else {
			Text("Loading")
				.onAppear {
					pokemonController.loadPokemon(from: pokemonResult)
				}
		}
	}
}

import NetworkHandler
struct PokemonDetail_Previews: PreviewProvider {
	static var previews: some View {
		let mock = NetworkMockingSession(mockData: MockData.bulbJSON, mockError: nil, mockDelay: 0)
		let pokontroller = PokemonController(networkLoader: mock)
		let bulbResult = PokemonResult(name: "bulbasaur", url: URL(string: "https://pokeapi.co/api/v2/pokemon/1/")!)
		let bulb = MockData.bulb
		PokemonDetail(pokemonResult: bulbResult, detailCoordinator: MainNavCoordinator(pokemonController: pokontroller), testPokemon: bulb)
	}
}
