//
//  NavCoordintor.swift
//  SwiftUI-NavCoordinator
//
//  Created by Michael Redig on 7/25/20.
//

import Foundation


protocol NavCoordinator: AnyObject {
	var childCoordinators: [NavCoordinator] { get set }
}
