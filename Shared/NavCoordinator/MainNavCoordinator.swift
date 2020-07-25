//
//  MainNavCoordinator.swift
//  SwiftUI-NavCoordinator
//
//  Created by Michael Redig on 7/25/20.
//

import Foundation

protocol PokemonControllerContainingNavCoordinator: NavCoordinator {
	var pokemonController: PokemonController { get }
}

class MainNavCoordinator: PokemonControllerContainingNavCoordinator {
	var childCoordinators: [NavCoordinator] = []

	let pokemonController: PokemonController

	init(pokemonController: PokemonController) {
		self.pokemonController = pokemonController
		print("inited new coordinator")
		pokemonController.loadPokemonList()
	}

}

extension MainNavCoordinator: PokemonListNavCoordinator {
	func getPokemonDetailView(from result: PokemonResult) -> PokemonDetail {
		PokemonDetail(pokemonResult: result, detailCoordinator: self)
	}
}

extension MainNavCoordinator: PokemonDetailNavCoordinator {}
