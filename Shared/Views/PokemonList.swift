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
	@State var selectedPokemon: PokemonResult?
	
	init(navCoordinator: PokemonListNavCoordinator) {
		self.navCoordinator = navCoordinator
		self.pokemonController = navCoordinator.pokemonController
	}
	
	var body: some View {
		List(pokemonController.pokemonList) { pokemon in
			NavigationLink(
				destination: navCoordinator.getPokemonDetailView(from: pokemon),
				label: {
					Text(pokemon.name.capitalized)
						.onLongPressGesture {
							selectedPokemon = pokemon
						}
				})
		}
		.navigationTitle("Pokemons!")
		.sheet(item: $selectedPokemon) { selected in
			// honestly, this isn't really a good use for a modal, but it demonstrates that modals work well (unlike how they technically "aren't" in the view hierarchy to inherit, say, `@EnvironmentObject`s)
			navCoordinator.getPokemonDetailView(from: selected)
		}
	}
}

struct PokemonList_Previews: PreviewProvider {
	static var previews: some View {
		PokemonList(navCoordinator: MainNavCoordinator(pokemonController: PokemonController()))
	}
}
