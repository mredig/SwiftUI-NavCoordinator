//
//  MainNavCoordinator.swift
//  SwiftUI-NavCoordinator
//
//  Created by Michael Redig on 7/25/20.
//

import SwiftUI

protocol PokemonControllerContainingNavCoordinator: NavCoordinator {
	var pokemonController: PokemonController { get }
}

class MainNavCoordinator: PokemonControllerContainingNavCoordinator, NavCoordinatorStarter {
	var childCoordinators: [NavCoordinator] = []

	let pokeDetailCoordinator: DetailNavCoordinator

	let pokemonController: PokemonController

	init(pokemonController: PokemonController) {
		self.pokemonController = pokemonController
		self.pokeDetailCoordinator = DetailNavCoordinator(pokemonController: pokemonController)
		print("inited new coordinator")
		pokemonController.loadPokemonList()
	}

	func start() -> some View {
		NavigationView {
			PokemonList(navCoordinator: self)
		}
	}
}

extension MainNavCoordinator: PokemonListNavCoordinator {
	func getPokemonDetailView(from result: PokemonResult) -> PokemonDetail {
		pokeDetailCoordinator.detailView(from: result)
	}
}
