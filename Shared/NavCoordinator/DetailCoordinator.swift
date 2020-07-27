//
//  DetailCoordinator.swift
//  SwiftUI-NavCoordinator
//
//  Created by Michael Redig on 7/26/20.
//

import SwiftUI

class DetailNavCoordinator: PokemonDetailNavCoordinator {
	typealias RootView = PokemonDetail

	let pokemonController: PokemonController
	var childCoordinators: [NavCoordinator] = []


	init(pokemonController: PokemonController) {
		self.pokemonController = pokemonController
	}

	func detailView(from result: PokemonResult) -> RootView {
		PokemonDetail(pokemonResult: result, detailCoordinator: self)
	}
}
