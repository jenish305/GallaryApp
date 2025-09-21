//
//  ImagePriviewVC.swift
//  Gallery application
//
//  Created by Jenish  Mac  on 21/09/25.
//

import UIKit
import FMPhotoPicker

class ImagePriviewVC: UIViewController {
    
    
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var imgPriview: UIImageView!
    
    var images: [ImageModel] = []
    var selectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.isTabBarHidden = true
        
        imgPriview.contentMode = .scaleAspectFill
            imgPriview.clipsToBounds = true
        
        loadImage(at: selectedIndex)
    }
    
    func config() -> FMPhotoPickerConfig {
        let selectMode: FMSelectMode?
        
        var mediaTypes = [FMMediaType]()
        
        
        var config = FMPhotoPickerConfig()
        
        config.selectMode = .single
        config.mediaTypes = [.image,.video]
        config.maxImage =  5
        config.maxVideo = 1
        config.forceCropEnabled = false
        config.eclipsePreviewEnabled = false
        
        
        config.availableCrops = [
            FMCrop.ratioSquare,
            FMCrop.ratioCustom,
            FMCrop.ratio4x3,
            FMCrop.ratio16x9,
            FMCrop.ratio9x16,
            FMCrop.ratioOrigin,
        ]
        
        config.availableFilters = []
        
        return config
    }
    
    private func loadImage(at index: Int) {
        guard index < images.count else { return }
        let model = images[index]
        if let url = URL(string: model.url) {
            imgPriview.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"))
        } else {
            imgPriview.image = UIImage(systemName: "photo")
        }
    }
    
    
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveTapped(_ sender: Any) {
        guard let image = imgPriview.image else { return }
           
           UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSaveCompletion(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @IBAction func btnFilterTapped(_ sender: Any) {
        let vc = FMImageEditorViewController(config: config(), sourceImage: imgPriview.image!)
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    // MARK: - Save Completion
       @objc private func imageSaveCompletion(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
           DispatchQueue.main.async {
               let alert = UIAlertController(
                   title: error == nil ? "Success" : "Error",
                   message: error == nil ? "Image saved to Photos!" : error?.localizedDescription,
                   preferredStyle: .alert
               )
               let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                   if error == nil {
                       self.navigationController?.popViewController(animated: true)
                   }
               }
               alert.addAction(okAction)
               self.present(alert, animated: true)
           }
       }

  
}


extension ImagePriviewVC: FMImageEditorViewControllerDelegate {
    func fmImageEditorViewController(_ editor: FMImageEditorViewController, didFinishEdittingPhotoWith photo: UIImage) {
        imgPriview.image = photo
        self.dismiss(animated: true, completion: nil)
    }
}
