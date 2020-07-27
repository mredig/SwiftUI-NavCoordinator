//
//  AsyncImage.swift
//  SwiftUI-NavCoordinator
//
//  Created by Michael Redig on 7/26/20.
//

import SwiftUI
import NetworkHandler

class AsyncImageLoader: ObservableObject {
	@Published private(set) var image: UIImage?

	private var _task: NetworkLoadingTask?
	private var task: NetworkLoadingTask? {
		get {
			Self.queue.sync {
				_task
			}
		}
		set {
			Self.queue.sync {
				_task = newValue
			}
		}
	}

//	let trackValue = Int.random(in: 0...500)

	private static let queue = DispatchQueue(label: "loadingQueue")

	func load(imageURL: URL) {
		task?.cancel()
		let request = imageURL.request
		task = NetworkHandler.default.transferMahOptionalDatas(with: request, usingCache: true) { [weak self] result in
			do {
				guard let data = try result.get() else { return }
				DispatchQueue.main.async {
					self?.image = UIImage(data: data)
				}
			} catch {
				if case let NetworkError.otherError(error: otherError as NSError) = error {
					if otherError.code == -999 {
						return
					}
				}
				NSLog("Error loading image '\(imageURL)': \(error)")
			}
		}
	}

	func cancel() {
		guard let task = task, task.status != .completed else { return }
//		print("cancelling \(trackValue)")
		task.cancel()
	}
}

struct AsyncImage<Placeholder: View>: View {

	let imageURL: URL?
	let placeholder: Placeholder
	@ObservedObject var loader: AsyncImageLoader

	private var imageConfigurations: [(Image) -> Image] = []

	// tracking state of whether `onAppear` has run yet or not to prevent `onDisappear` from running first
	@State private var appearances = 0

	init(imageURL: URL?, loader: AsyncImageLoader = .init(), @ViewBuilder placeholder: () -> Placeholder) {
		self.imageURL = imageURL
		self.placeholder = placeholder()
		self.loader = loader
	}

	private var image: some View {
		Group {
			if let image = loader.image {
				runConfigurations(image: image)
			} else {
				placeholder
					.onAppear {
						guard let url = imageURL else { return }
						loader.load(imageURL: url)
//						print("loading \(loader.trackValue)")
						appearances += 1
					}
					.onDisappear {
						appearances -= 1
						guard appearances <= 0 else { return }
						loader.cancel()
					}
			}
		}
	}

	var body: some View {
		image
	}

	func runConfigurations(image: UIImage) -> some View {
		imageConfigurations.reduce(Image(uiImage: image)) { (previous, configuration) in
			configuration(previous)
		}
	}
}

// MARK: - Image Configurations
extension AsyncImage {
	private func configure(_ block: @escaping (Image) -> Image) -> AsyncImage {
		var result = self
		result.imageConfigurations.append(block)
		return result
	}

	func resizable(
		capInsets: EdgeInsets = EdgeInsets(),
		resizingMode: Image.ResizingMode = .stretch) -> AsyncImage {
		configure { $0.resizable(capInsets: capInsets, resizingMode: resizingMode) }
	}

	func renderingMode(_ renderingMode: Image.TemplateRenderingMode?) -> AsyncImage {
		configure { $0.renderingMode(renderingMode) }
	}

	func interpolation(_ interpolation: Image.Interpolation) -> AsyncImage {
		configure { $0.interpolation(interpolation) }
	}

	func antialiased(_ isAntialiased: Bool) -> AsyncImage {
		configure { $0.antialiased(isAntialiased) }
	}
}

struct AsyncImage_Previews: PreviewProvider {
	static var previews: some View {
		AsyncImage(imageURL: URL(string: "https://images.unsplash.com/photo-1523676060187-f55189a71f5e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80")) {
			Text("loading!")
		}
	}
}
