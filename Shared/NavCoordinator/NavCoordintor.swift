//
//  NavCoordintor.swift
//  SwiftUI-NavCoordinator
//
//  Created by Michael Redig on 7/25/20.
//

import SwiftUI

protocol NavCoordinator: AnyObject {
	var childCoordinators: [NavCoordinator] { get set }
}

protocol NavCoordinatorStarter: NavCoordinator {
	associatedtype RootView: View
	func start() -> RootView
}
