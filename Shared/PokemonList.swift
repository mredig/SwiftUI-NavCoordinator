//
//  PokemonList.swift
//  Shared
//
//  Created by Michael Redig on 7/25/20.
//

import SwiftUI

struct PokemonList: View {

	let navCoordinator: MainNavCoordinator
	@ObservedObject var pokemonController: PokemonController

	init(navCoordinator: MainNavCoordinator) {
		self.navCoordinator = navCoordinator
		self.pokemonController = navCoordinator.pokemonController
	}

	var body: some View {
		List(pokemonController.pokemonList, id: \.id) { pokemon in
			Text(pokemon.name)
		}
	}
}

//struct PokemonList_Previews: PreviewProvider {
//    static var previews: some View {
//        PokemonList()
//    }
//}
