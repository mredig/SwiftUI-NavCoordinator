//
//  SwiftUI_NavCoordinatorApp.swift
//  Shared
//
//  Created by Michael Redig on 7/25/20.
//

import SwiftUI

@main
struct SwiftUI_NavCoordinatorApp: App {

//	@StateObject var pokemonController = PokemonController()
	let coordinator = MainNavCoordinator(pokemonController: PokemonController())

    var body: some Scene {
        WindowGroup {
            PokemonList(navCoordinator: coordinator)
        }
    }
}
