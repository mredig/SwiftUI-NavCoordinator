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

	init(pokemonResult: PokemonResult, detailCoordinator: PokemonDetailNavCoordinator) {
		self.detailCoordinator = detailCoordinator
		self.pokemonResult = pokemonResult
		self.pokemonController = detailCoordinator.pokemonController
		self.pokemon = detailCoordinator.pokemonController.cachedPokemon[pokemonResult.id]
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

struct PokemonDetail_Previews: PreviewProvider {
	static var previews: some View {
		let dodrio = PokemonResult(name: "dodrio", url: URL(string: "https://pokeapi.co/api/v2/pokemon/85/")!)
		PokemonDetail(pokemonResult: dodrio, detailCoordinator: MainNavCoordinator(pokemonController: PokemonController()))
	}
}
