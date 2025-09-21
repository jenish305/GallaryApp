//
//  GalleryViewModel.swift
//  Gallery application
//
//  Created by Jenish  Mac  on 20/09/25.
//

import Foundation

class GalleryViewModel {
    private var allImages: [ImageModel] = []
    private(set) var displayedImages: [ImageModel] = []

    private let pageSize = 20
    private var currentPage = 0
    private var isLoading = false

    var reloadCollectionView: (() -> Void)?
    var showLoader: (() -> Void)?
    var hideLoader: (() -> Void)?

    init() { loadData() }

    private func loadData() {
        if NetworkManager.shared.isConnected {
            let urls = (1...50).map { "https://picsum.photos/id/\($0)/500/500" }
            allImages = urls.enumerated().map { (index, url) in
                ImageModel(id: index, url: url)
            }
            CoreDataManager.shared.saveImages(urls)
        } else {
            let urls = CoreDataManager.shared.fetchImages()
            allImages = urls.enumerated().map { (index, url) in
                ImageModel(id: index, url: url)
            }
        }
    }

    func loadNextPage() {
        guard !isLoading else { return }
        guard !allImages.isEmpty else { return } 

        isLoading = true
        showLoader?()

        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }

            let startIndex = self.currentPage * self.pageSize
            let endIndex = min(startIndex + self.pageSize, self.allImages.count)
            guard startIndex < endIndex else {
                self.isLoading = false
                DispatchQueue.main.async { self.hideLoader?() }
                return
            }

            let newImages = Array(self.allImages[startIndex..<endIndex])
            self.displayedImages.append(contentsOf: newImages)
            self.currentPage += 1
            self.isLoading = false

            DispatchQueue.main.async {
                self.hideLoader?()
                self.reloadCollectionView?()
            }
        }
    }

    func numberOfItems() -> Int { displayedImages.count }
    func image(at index: Int) -> ImageModel { displayedImages[index] }
}
