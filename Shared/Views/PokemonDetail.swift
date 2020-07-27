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
			VStack {
				HStack(alignment: .firstTextBaseline) {
					Text(pokemon.name.capitalized)
						.font(.title)
					Text("\(pokemon.id)")
				}
				HStack(alignment: .top) {
					VStack(alignment: .leading) {
						Text("Base Stats:")
							.font(.title2)
						ForEach(pokemon.stats) { statContainer in
							Text("\(statContainer.stat.name.capitalized): \(statContainer.baseStat)")
						}
					}
					.padding(.leading)
					List(pokemon.moves.map(\.move)) { move in
						Text(move.name.capitalized)
					}
				}
				ScrollView(.horizontal) {
					LazyHStack(alignment: .bottom, content: {
						ForEach(pokemon.sprites.allSprites) { spriteURL in
							let loader = AsyncImageLoader()
							AsyncImage(imageURL: spriteURL, loader: loader) {
								ProgressView()
									.frame(minWidth: 50, minHeight: 50)
									.padding()
							}
						}
					})
					.frame(maxHeight: 100)
				}

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
		let coord = DetailNavCoordinator(pokemonController: pokontroller)
		PokemonDetail(pokemonResult: bulbResult,
					  detailCoordinator: coord,
					  testPokemon: bulb)
	}
}
