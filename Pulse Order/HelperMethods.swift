//
//  HelperMethods.swift
//  ThirdEye Reporter
//
//  Created by Tanay Kothari on 09/04/16.
//  Copyright © 2016 Tanay Kothari. All rights reserved.
//

import Foundation
import AVFoundation

class HelperMethods
{
    func getDateForNotification(date: NSDate) -> String
    {
        let interval = -date.timeIntervalSinceNow
        if (interval < 60)
        { return "Just Now" }
        if (interval < 120)
        { return "A minute ago" }
        if (interval < 60 * 60)
        { return "\(Int(floor(interval / 60))) minutes ago" }
        if interval < 2 * 60 * 60
        { return "About an hour ago" }
        if (interval < 60 * 60 * 24)
        { return "About \(Int(floor(interval / (60 * 60)))) hours ago" }
        if (interval < 2 * 60 * 60 * 24)
        { return "Yesterday" }
        let days = Int(round(interval / (60 * 60 * 24)))
        if (days > 365)
        {
            let years = days / 365
            return "About \(years) year" + (years > 1 ? "s": "") + " ago"
        }
        if (days > 30)
        {
            let months = days / 30
            return "About \(months) month" + (months > 1 ? "s": "") + " ago"
        }
        if (days > 7)
        { return "About \(days / 7) week" + (days >= 14 ? "s" : "") + " ago" }
        if (days <= 1)
        { return "About a day ago" }
        else
        { return "About \(days) days ago" }
    }
    
    func resizeImage(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage
    {
        let newSize = CGSizeMake(width, height)
        let newRect = CGRectMake(0, 0, width, height)
        UIGraphicsBeginImageContext(newSize)
        image.drawInRect(newRect)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
    func scaleDownImageAndCircle (image: UIImage, minLen: CGFloat) -> UIImage
    {
        var img: UIImage
        if image.size.width < image.size.height
        {
            let scale = image.size.width / minLen
            img = resizeImage(image, width: image.size.width / scale, height: image.size.height / scale)
        }
        else
        {
            let scale = image.size.height / minLen
            img = resizeImage(image, width: image.size.width / scale, height: image.size.height / scale)
        }
        img = cropImage(img, width: minLen, height: minLen)
        var half: CGFloat = 2.0
        return roundedCornerImage(img, cornerSize: minLen / half, borderSize: 1.0)
    }
    
    func cropImage(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage
    {
        let clippedRect = CGRectMake((image.size.width - width) / 2, (image.size.height - height) / 2, width, height)
        let imageRef = CGImageCreateWithImageInRect(image.CGImage, clippedRect)
        let croppedImage = UIImage(CGImage: imageRef!)
        return croppedImage
    }
    
    func videoSnapshot(vidURL: NSURL) -> UIImage?
    {
        let asset = AVURLAsset(URL: vidURL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        let timestamp = CMTime(seconds: 1, preferredTimescale: 60)
        
        do
        {
            let imageRef = try generator.copyCGImageAtTime(timestamp, actualTime: nil)
            return UIImage(CGImage: imageRef)
        }
        catch let error as NSError
        {
            print("Image generation failed with error \(error)")
            return nil
        }
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
    
    func roundedCornerImage(image: UIImage, cornerSize: CGFloat, borderSize: CGFloat) -> UIImage
    {
        // Build a context that's the same dimensions as the new size
        let context = CGBitmapContextCreate(nil, Int(image.size.width), Int(image.size.height), CGImageGetBitsPerComponent(image.CGImage), 0, CGImageGetColorSpace(image.CGImage), CGImageGetBitmapInfo(image.CGImage).rawValue)
        
        // Create a clipping path with rounded corners
        CGContextBeginPath(context);
        addRoundedRectToPath(CGRectMake(borderSize, borderSize, image.size.width - borderSize * 2, image.size.height - borderSize * 2), context: context!, ovalWidth: cornerSize, ovalHeight: cornerSize)
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