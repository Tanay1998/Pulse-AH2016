//
//  ImageMethods.swift
//  Proximity
//
//  Created by Tanay on 2/9/15.
//  Copyright (c) 2015 Tanay. All rights reserved.
//

import Foundation

class ImageMethods
{
    func resizeImage(img: UIImage, width: CGFloat, height: CGFloat) -> UIImage
    {
        let image = centerCropImage(correctRotation(image: img))
        let newSize = CGSizeMake(width, height)
        let newRect = CGRectMake(0, 0, width, height)
        UIGraphicsBeginImageContext(newSize)
        image.drawInRect(newRect)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return roundedCornerImage(resizedImage, cornerSize: Int(resizedImage.size.width / 2), borderSize: CGFloat(1))
    }
    
    func correctRotation(image image: UIImage) -> UIImage
    {
        let size = image.size
        UIGraphicsBeginImageContext(size)
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func centerCropImage(image: UIImage) -> UIImage
    {
        let squareLen = min(image.size.width, image.size.height)
        let clippedRect = CGRectMake((image.size.width - squareLen) / 2, (image.size.height - squareLen) / 2, squareLen, squareLen)
        let imageRef = CGImageCreateWithImageInRect(image.CGImage, clippedRect)
        let croppedImage = UIImage(CGImage: imageRef!)
        return croppedImage
    }
    
    func addRoundedRectToPath(rect: CGRect, context: CGContext, ovalWidth: CGFloat, ovalHeight: CGFloat)
    {
        if ovalWidth == 0 || ovalHeight == 0 { return }
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
        CGContextScaleCTM(context, ovalWidth, ovalHeight);
        let fw = CGRectGetWidth(rect) / ovalWidth;
        let fh = CGRectGetHeight(rect) / ovalHeight;
        CGContextMoveToPoint(context, fw, fh/2);
        CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
        CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
        CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
        CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
        CGContextClosePath(context);
        CGContextRestoreGState(context);
    }
    
    func roundedCornerImage(image: UIImage, cornerSize: Int, borderSize: CGFloat) -> UIImage
    {
        // Build a context that's the same dimensions as the new size
        let context = CGBitmapContextCreate(nil, Int(image.size.width), Int(image.size.height), CGImageGetBitsPerComponent(image.CGImage), 0, CGImageGetColorSpace(image.CGImage), CGImageGetBitmapInfo(image.CGImage).rawValue)

        // Create a clipping path with rounded corners
        CGContextBeginPath(context);
        addRoundedRectToPath(CGRectMake(borderSize, borderSize, image.size.width - borderSize * 2, image.size.height - borderSize * 2), context: context!, ovalWidth: CGFloat(cornerSize), ovalHeight: CGFloat(cornerSize))
        CGContextClosePath(context);
        CGContextClip(context);
        
        // Draw the image to the context; the clipping path will make anything outside the rounded rect transparent
        CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage)
        
        // Create a CGImage from the context
        let clippedImage = CGBitmapContextCreateImage(context)
        
        // Create a UIImage from the CGImage
        let roundedImage = UIImage(CGImage: clippedImage!)
        
        return roundedImage
    }
}
