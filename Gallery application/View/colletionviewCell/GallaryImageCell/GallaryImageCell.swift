//
//  GallaryImageCell.swift
//  Gallery application
//
//  Created by Jenish  Mac  on 20/09/25.
//

import UIKit
import SDWebImage

class GallaryImageCell: UICollectionViewCell {
    

    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = 10
    }
    
    func configure(with model: ImageModel) {
           if let url = URL(string: model.url) {
               img.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
           }
       }

}
