//
//  UIColorExt.swift
//  Gallery application
//
//  Created by Jenish  Mac  on 20/09/25.
//

import Foundation
import UIKit

//=================================================================================
//MARK: - label Style -


class imgUserProfile: UIImageView {
    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.height/2
    }
}

class labelBold14: UILabel {
    override func awakeFromNib() {
        
    }
}

//=================================================================================
//MARK: - vwCornerRedius -

class vwSampleMainCornerRedius: UIView {
    override func awakeFromNib() {
        self.layer.cornerRadius = 16 * ScreenSize.widthAspectRatio
    }
}

class vwSampleStepCornerRedius: UIView {
    override func awakeFromNib() {
        self.layer.cornerRadius = 20
    }
}

class vwSampleBottomCornerRedius: UIView {
    override func awakeFromNib() {
        self.layer.cornerRadius = 6
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
}

class imgSampleGendarCornerRedius: UIImageView {
    override func awakeFromNib() {
        self.layer.cornerRadius = self.layer.frame.width / 2
    }
}

class imgSampleGendarSelectCornerRedius: UIImageView {
    override func awakeFromNib() {
        self.layer.cornerRadius = self.layer.frame.width / 2
        
        self.layer.borderWidth = 1.0
    }
}

class imgSampleCategeryCornerRedius: UIImageView {
    override func awakeFromNib() {
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
    }
}

class imgSampleCategerySelectCornerRedius: UIImageView {
    override func awakeFromNib() {
        self.layer.cornerRadius = 8
        
        self.layer.borderWidth = 1.0
    }
}

class RoundedCorner: UIButton {
   override func awakeFromNib() {
       self.layer.cornerRadius = self.frame.height/2
       self.clipsToBounds = true
   }
}

class ViewRoundedCorner: UIView {
   override func awakeFromNib() {
       self.layer.cornerRadius =  10
       self.clipsToBounds = true
   }
}

//=================================================================================
//MARK: - Fonts -

class WitchMagic: UILabel {
    override func awakeFromNib() {
        self.font = UIFont(name: "Witch Magic", size: 20)
    }
}


class PopinsReg: UILabel {
    override func awakeFromNib() {
        self.font = UIFont(name: "Poppins-Regular", size: 20)
    }
}
