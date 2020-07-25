//
//  PokemonList.swift
//  Shared
//
//  Created by Michael Redig on 7/25/20.
//

import SwiftUI

protocol PokemonListNavCoordinator: PokemonControllerContainingNavCoordinator {
	func getPokemonDetailView(from result: PokemonResult) -> PokemonDetail
}

struct PokemonList: View {
	
	let navCoordinator: PokemonListNavCoordinator
	@ObservedObject var pokemonController: PokemonController
	
	init(navCoordinator: PokemonListNavCoordinator) {
		self.navCoordinator = navCoordinator
		self.pokemonController = navCoordinator.pokemonController
	}
	
	var body: some View {
		List(pokemonController.pokemonList, id: \.id) { pokemon in
			NavigationLink(
				destination: navCoordinator.getPokemonDetailView(from: pokemon),
				label: {
					Text(pokemon.name.capitalized)
				})
		}
		.navigationTitle("Pokemons!")
	}
}

struct PokemonList_Previews: PreviewProvider {
	static var previews: some View {
		PokemonList(navCoordinator: MainNavCoordinator(pokemonController: PokemonController()))
	}
}
