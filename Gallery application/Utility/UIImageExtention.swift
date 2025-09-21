//
//  UIColorExt.swift
//  Gallery application
//
//  Created by Jenish  Mac  on 20/09/25.
//


import UIKit

extension String {
    
    static func uniqueFilename(withPrefix prefix: String? = nil) -> String {
        let uniqueString = ProcessInfo.processInfo.globallyUniqueString
        
        if prefix != nil {
            return "\(prefix!)-\(uniqueString)"
        }
        
        return uniqueString
    }
    
}

extension UIImage {
    
    func upOrientationImage() -> UIImage? {
        switch imageOrientation {
        case .up:
            return self
        default:
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            draw(in: CGRect(origin: .zero, size: size))
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return result
        }
    }
    
    func ResizeImageOriginalSize(targetSize: CGSize) -> UIImage {
        var actualHeight: Float = Float(self.size.height)
        var actualWidth: Float = Float(self.size.width)
        let maxHeight: Float = Float(targetSize.height)
        let maxWidth: Float = Float(targetSize.width)
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        var compressionQuality: Float = 0.5
        //50 percent compression
        
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
                compressionQuality = 1.0
            }
        }
        
        actualWidth = 512
        actualHeight = 512
        compressionQuality = 1.0
        
        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContextWithOptions(rect.size, false, CGFloat(compressionQuality))
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    /// Represents a scaling mode
    enum ScalingMode {
        case aspectFill
        case aspectFit
        
        /// Calculates the aspect ratio between two sizes
        ///
        /// - parameters:
        ///     - size:      the first size used to calculate the ratio
        ///     - otherSize: the second size used to calculate the ratio
        ///
        /// - return: the aspect ratio between the two sizes
        func aspectRatio(between size: CGSize, and otherSize: CGSize) -> CGFloat {
            let aspectWidth  = size.width/otherSize.width
            let aspectHeight = size.height/otherSize.height
            
            switch self {
            case .aspectFill:
                return max(aspectWidth, aspectHeight)
            case .aspectFit:
                return min(aspectWidth, aspectHeight)
            }
        }
    }
    
    /// Scales an image to fit within a bounds with a size governed by the passed size. Also keeps the aspect ratio.
    ///
    /// - parameter:
    ///     - newSize:     the size of the bounds the image must fit within.
    ///     - scalingMode: the desired scaling mode
    ///
    /// - returns: a new scaled image.
    func scaled(to newSize: CGSize, scalingMode: UIImage.ScalingMode = .aspectFill) -> UIImage {
        
        let aspectRatio = scalingMode.aspectRatio(between: newSize, and: size)
        
        /* Build the rectangle representing the area to be drawn */
        var scaledImageRect = CGRect.zero
        
        scaledImageRect.size.width  = size.width * aspectRatio
        scaledImageRect.size.height = size.height * aspectRatio
        scaledImageRect.origin.x    = (newSize.width - size.width * aspectRatio) / 2.0
        scaledImageRect.origin.y    = (newSize.height - size.height * aspectRatio) / 2.0
        
        /* Draw and retrieve the scaled image */
        UIGraphicsBeginImageContext(newSize)
        
        draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
    
    
    func ResizeImageOriginalSize96() -> UIImage {
        var actualHeight: Float = Float(self.size.height)
        var actualWidth: Float = Float(self.size.width)
        var compressionQuality: Float = 0.5
        //50 percent compression
   
        actualWidth = 96
        actualHeight = 96
        compressionQuality = 1.0
        
        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContextWithOptions(rect.size, false, CGFloat(compressionQuality))
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func scaleImage(width: CGFloat? = nil, height: CGFloat? = nil, scaleMode: UIImageScaleMode = .AspectFit(.Center), trim: Bool = false) -> UIImage {
        let preWidthScale = width.map { $0 / size.width }
        let preHeightScale = height.map { $0 / size.height }
        var widthScale = preWidthScale ?? preHeightScale ?? 1
        var heightScale = preHeightScale ?? widthScale
        switch scaleMode {
        case .AspectFit(_):
            let scale = min(widthScale, heightScale)
            widthScale = scale
            heightScale = scale
        case .AspectFill:
            let scale = max(widthScale, heightScale)
            widthScale = scale
            heightScale = scale
        default:
            break
        }
        let newWidth = size.width * widthScale
        let newHeight = size.height * heightScale
        let canvasWidth = trim ? newWidth : (width ?? newWidth)
        let canvasHeight = trim ? newHeight : (height ?? newHeight)
        
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: canvasWidth, height: canvasHeight), false, 0)

        var originX: CGFloat = 0
        var originY: CGFloat = 0
        switch scaleMode {
        case .AspectFit(let alignment):
            switch alignment {
            case .Center:
                originX = (canvasWidth - newWidth) / 2
                originY = (canvasHeight - newHeight) / 2
            case .Top:
                originX = (canvasWidth - newWidth) / 2
            case .Left:
                originY = (canvasHeight - newHeight) / 2
            case .Bottom:
                originX = (canvasWidth - newWidth) / 2
                originY = canvasHeight - newHeight
            case .Right:
                originX = canvasWidth - newWidth
                originY = (canvasHeight - newHeight) / 2
            case .TopLeft:
                break
            case .TopRight:
                originX = canvasWidth - newWidth
            case .BottomLeft:
                originY = canvasHeight - newHeight
            case .BottomRight:
                originX = canvasWidth - newWidth
                originY = canvasHeight - newHeight
            }
        default:
            break
        }
        
        self.draw(in: CGRect.init(x: originX, y: originY, width: newWidth, height: newHeight))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}


enum UIImageAlignment {
    case Center, Left, Top, Right, Bottom, TopLeft, BottomRight, BottomLeft, TopRight
}

enum UIImageScaleMode {
    case Fill,
    AspectFill,
    AspectFit(UIImageAlignment)
}

extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}

extension UIImage {
    func replaceColor(targetColor: UIColor, withColor newColor: UIColor, tolerance: CGFloat = 0.0) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }

        let width = cgImage.width
        let height = cgImage.height
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        var pixelData = [UInt8](repeating: 0, count: width * height * bytesPerPixel)

        guard let context = CGContext(data: &pixelData,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil
        }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        let targetComponents = targetColor.cgColor.components ?? [0, 0, 0, 0]
        let newComponents = newColor.cgColor.components ?? [0, 0, 0, 0]

        for y in 0..<height {
            for x in 0..<width {
                let pixelIndex = (y * width + x) * bytesPerPixel
                let red = CGFloat(pixelData[pixelIndex]) / 255.0
                let green = CGFloat(pixelData[pixelIndex + 1]) / 255.0
                let blue = CGFloat(pixelData[pixelIndex + 2]) / 255.0
                let alpha = CGFloat(pixelData[pixelIndex + 3]) / 255.0

                if abs(red - targetComponents[0]) <= tolerance &&
                    abs(green - targetComponents[1]) <= tolerance &&
                    abs(blue - targetComponents[2]) <= tolerance &&
                    alpha == targetComponents[3] {

                    pixelData[pixelIndex] = UInt8(newComponents[0] * 255)
                    pixelData[pixelIndex + 1] = UInt8(newComponents[1] * 255)
                    pixelData[pixelIndex + 2] = UInt8(newComponents[2] * 255)
                    pixelData[pixelIndex + 3] = UInt8(newComponents[3] * 255)
                }
            }
        }

        guard let outputCGImage = context.makeImage() else { return nil }
        return UIImage(cgImage: outputCGImage)
    }
}


extension UIImageView {

    @discardableResult func replace(color: UIColor, withColor replacingColor: UIColor) -> Bool {
        guard let inputCGImage = self.image?.cgImage else {
            return false
        }
        let colorSpace       = CGColorSpaceCreateDeviceRGB()
        let width            = inputCGImage.width
        let height           = inputCGImage.height
        let bytesPerPixel    = 4
        let bitsPerComponent = 8
        let bytesPerRow      = bytesPerPixel * width
        let bitmapInfo       = RGBA32.bitmapInfo

        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            print("unable to create context")
            return false
        }
        context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        guard let buffer = context.data else {
            return false
        }

        let pixelBuffer = buffer.bindMemory(to: RGBA32.self, capacity: width * height)

        let inColor = RGBA32(color: color)
        let outColor = RGBA32(color: replacingColor)
        for row in 0 ..< Int(height) {
            for column in 0 ..< Int(width) {
                let offset = row * width + column
                if pixelBuffer[offset] == inColor {
                    pixelBuffer[offset] = outColor
                }
            }
        }

        guard let outputCGImage = context.makeImage() else {
            return false
        }
        self.image = UIImage(cgImage: outputCGImage, scale: self.image!.scale, orientation: self.image!.imageOrientation)
        return true
    }

}

struct RGBA32: Equatable {
    private var color: UInt32

    var redComponent: UInt8 {
        return UInt8((self.color >> 24) & 255)
    }

    var greenComponent: UInt8 {
        return UInt8((self.color >> 16) & 255)
    }

    var blueComponent: UInt8 {
        return UInt8((self.color >> 8) & 255)
    }

    var alphaComponent: UInt8 {
        return UInt8((self.color >> 0) & 255)
    }

    init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        self.color = (UInt32(red) << 24) | (UInt32(green) << 16) | (UInt32(blue) << 8) | (UInt32(alpha) << 0)
    }

    init(color: UIColor) {
        let components = color.cgColor.components ?? [0.0, 0.0, 0.0, 1.0]
        let colors = components.map { UInt8($0 * 255) }
        self.init(red: colors[0], green: colors[1], blue: colors[2], alpha: colors[3])
    }

    static let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue

    static func ==(lhs: RGBA32, rhs: RGBA32) -> Bool {
        return lhs.color == rhs.color
    }

}

extension UIImage {
    
    // colorize image with given tint color
    // this is similar to Photoshop's "Color" layer blend mode
    // this is perfect for non-greyscale source images, and images that have both highlights and shadows that should be preserved
    // white will stay white and black will stay black as the lightness of the image is preserved
    func tint(tintColor: UIColor) -> UIImage {
        
        return modifiedImage { context, rect in
            // draw black background - workaround to preserve color of partially transparent pixels
            context.setBlendMode(.normal)
            UIColor.white.setFill()
            context.fill(rect)
            
            // draw original image
            context.setBlendMode(.normal)
            context.draw(self.cgImage!, in: rect)
            
            // tint image (loosing alpha) - the luminosity of the original image is preserved
            context.setBlendMode(.color)
            tintColor.setFill()
            context.fill(rect)
            
            // mask by alpha values of original image
            context.setBlendMode(.destinationIn)
            context.draw(self.cgImage!, in: rect)
        }
    }
    
    // fills the alpha channel of the source image with the given color
    // any color information except to the alpha channel will be ignored
    func fillAlpha(fillColor: UIColor) -> UIImage {
        
        return modifiedImage { context, rect in
            // draw tint color
            context.setBlendMode(.normal)
            fillColor.setFill()
            context.fill(rect)
//            context.fillCGContextFillRect(context, rect)
            
            // mask by alpha values of original image
            context.setBlendMode(.destinationIn)
            context.draw(self.cgImage!, in: rect)
        }
    }
    
    private func modifiedImage( draw: (CGContext, CGRect) -> ()) -> UIImage {
        
        // using scale correctly preserves retina images
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context: CGContext! = UIGraphicsGetCurrentContext()
        assert(context != nil)
        
        // correctly rotate image
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        
        draw(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}


