//
//  MainNavCoordinator.swift
//  SwiftUI-NavCoordinator
//
//  Created by Michael Redig on 7/25/20.
//

import Foundation

class MainNavCoordinator: NavCoordinator {
	var childCoordinators: [NavCoordinator] = []

	let pokemonController: PokemonController

	init(pokemonController: PokemonController) {
		self.pokemonController = pokemonController
		print("inited new coordinator")
		pokemonController.loadPokemonList()
	}

}
