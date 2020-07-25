//
//  PokemonDetail.swift
//  SwiftUI-NavCoordinator
//
//  Created by Michael Redig on 7/25/20.
//

import SwiftUI

struct PokemonDetail: View {

	let pokemonResult: PokemonResult
	let pokemon: Pokemon?
	let detailCoordinator: MainNavCoordinator
	@ObservedObject var pokemonController: PokemonController

	init(pokemonResult: PokemonResult, detailCoordinator: MainNavCoordinator) {
		self.detailCoordinator = detailCoordinator
		self.pokemonResult = pokemonResult
		self.pokemonController = detailCoordinator.pokemonController
		self.pokemon = detailCoordinator.pokemonController.cachedPokemon[pokemonResult.id]
	}

    var body: some View {
		Text(pokemon?.name ?? "Loading")
			.onAppear {
				pokemonController.loadPokemon(from: pokemonResult)
			}
    }
}

//struct PokemonDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        PokemonDetail()
//    }
//}
