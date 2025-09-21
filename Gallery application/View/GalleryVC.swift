//
//  GalleryVC.swift
//  Gallery application
//
//  Created by Jenish  Mac  on 19/09/25.
//

import UIKit
import NVActivityIndicatorView

class GalleryVC: UIViewController {
    
    
    @IBOutlet weak var imgPerson: UIImageView!
    @IBOutlet weak var clvGallary: UICollectionView!
    @IBOutlet weak var Initialloadingindicator: NVActivityIndicatorView!
    
    private let viewModel = GalleryViewModel()
    private var isInitialLoad = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupCollectionView()
        setupBindings()
                
        viewModel.loadNextPage()
        
        imgPerson.layer.cornerRadius = imgPerson.frame.size.width / 2
        imgPerson.clipsToBounds = true
        
        if let urlString = UserDefaults.standard.string(forKey: "userProfilePic"),
           let url = URL(string: urlString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imgPerson.image = image
                    }
                }
            }
        } else {
            imgPerson.image = UIImage(systemName: "person.circle")
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.isTabBarHidden = false
    }
    
    func showLoader() {
        Initialloadingindicator.type = .ballSpinFadeLoader
        Initialloadingindicator.startAnimating()

        if isInitialLoad {
            clvGallary.isHidden = true
        } else {
            clvGallary.isHidden = false
            view.bringSubviewToFront(Initialloadingindicator)
        }
    }

    func hideLoader() {
        clvGallary.isHidden = false
        Initialloadingindicator.stopAnimating()
    }
    
    private func setupBindings() {
            viewModel.reloadCollectionView = { [weak self] in
                self?.clvGallary.reloadData()
                self?.isInitialLoad = false
            }
            
            viewModel.showLoader = { [weak self] in
                self?.showLoader()
            }
            
            viewModel.hideLoader = { [weak self] in
                self?.hideLoader()
            }
        }
    
    private func setupCollectionView() {
            let nib = UINib(nibName: "GallaryImageCell", bundle: nil)
            clvGallary.register(nib, forCellWithReuseIdentifier: "GallaryImageCell")
            clvGallary.delegate = self
            clvGallary.dataSource = self
            clvGallary.collectionViewLayout = createLayout()
        }
        
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (_, _) -> NSCollectionLayoutSection? in
            
            // Common item
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            // Pattern A → 3 equal squares
            let threeItemGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalWidth(1.0/3.0)
                ),
                subitem: item,
                count: 3
            )
            
            // Pattern B → left big + right stack
            let smallStack = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.5),
                    heightDimension: .fractionalWidth(1.0)
                ),
                subitem: item,
                count: 2
            )
            let bigRectangle = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.5),
                    heightDimension: .fractionalWidth(1.0)
                ),
                subitem: item,
                count: 1
            )
            let patternLeftBig = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalWidth(1.0)
                ),
                subitems: [bigRectangle, smallStack]
            )
            let patternRightBig = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalWidth(1.0)
                ),
                subitems: [smallStack, bigRectangle]
            )
            
            // Combine → cycle them manually
            let nestedGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(1200) // enough height for multiple patterns
                ),
                subitems: [threeItemGroup, patternLeftBig, patternRightBig]
            )
            
            let section = NSCollectionLayoutSection(group: nestedGroup)
            return section
        }
    }
    
    
    
}

extension GalleryVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GallaryImageCell",
                                                      for: indexPath) as! GallaryImageCell
        let model = viewModel.image(at: indexPath.item)
        cell.configure(with: model)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = viewModel.image(at: indexPath.item)
        let vc = storyboard?.instantiateViewController(identifier: "ImagePriviewVC") as! ImagePriviewVC
        vc.images = viewModel.displayedImages
        vc.selectedIndex = indexPath.item
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let height = scrollView.frame.size.height
            
            if offsetY > contentHeight - height - 200 {
                viewModel.loadNextPage()
            }
        }
}

    

    
