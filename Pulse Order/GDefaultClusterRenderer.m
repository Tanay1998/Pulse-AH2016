#import <CoreText/CoreText.h>
#import "GDefaultClusterRenderer.h"
#import "GQuadItem.h"
#import "GCluster.h"

@implementation GDefaultClusterRenderer {
    GMSMapView *_map;
    NSMutableArray *_markerCache;
}

- (id)initWithMapView:(GMSMapView*)googleMap {
    if (self = [super init]) {
        _map = googleMap;
        _markerCache = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)clustersChanged:(NSSet*)clusters {
    for (GMSMarker *marker in _markerCache) {
        marker.map = nil;
    }
    
    [_markerCache removeAllObjects];
    
    for (id <GCluster> cluster in clusters)
    {
        GMSMarker *marker;
        marker = [[GMSMarker alloc] init];
        [_markerCache addObject:marker];
        NSUInteger count = cluster.items.count;
        
        NSLog(@"%@", cluster.items);
        if (count > 1)
        {
            marker.icon = [self generateClusterIconWithCount:count];
            marker.title = [NSString stringWithFormat:@"%lu reports", (unsigned long)count];
        }
        else
        {
            marker.icon = cluster.marker.icon;
            marker.title = cluster.username;
        }
        marker.userData = cluster.username;
        NSLog([marker userData]);
        marker.position = cluster.marker.position;
        marker.map = _map;
    }
}

- (UIImage*)generateClusterIconWithCount:(NSUInteger)count {
    
    int diameter = 36;
    CGRect rect = CGRectMake(0, 0, diameter, diameter);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);

    CGContextRef ctx = UIGraphicsGetCurrentContext();

    // Draws circle
    UIImage *circ = [UIImage imageNamed:@"orange-map"];
    [circ drawInRect:CGRectMake(0, 0, 42, 36)];

    CTFontRef myFont = CTFontCreateWithName( (CFStringRef)@"Avenir-Medium", 15.0f, NULL);
    
    UIColor *fontColor = [UIColor whiteColor];
    
    NSDictionary *attributesDict = [NSDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)myFont, (id)kCTFontAttributeName,
                    fontColor, (id)kCTForegroundColorAttributeName, nil];

    // create a naked string
    NSString *string = [[NSString alloc] initWithFormat:@"%lu", (unsigned long)count];

    NSAttributedString *stringToDraw = [[NSAttributedString alloc] initWithString:string
                                                                       attributes:attributesDict];

    // flip the coordinate system
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    CGContextTranslateCTM(ctx, 0, diameter);
    CGContextScaleCTM(ctx, 1.0, -1.0);

    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)(stringToDraw));
    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, CFRangeMake(0, stringToDraw.length),                                                                         NULL, CGSizeMake(diameter, diameter), NULL);
    CFRelease(frameSetter);
    
    //Get the position on the y axis
    float midHeight = diameter;
    midHeight -= suggestedSize.height;
    
    float midWidth = diameter / 2;
    midWidth -= suggestedSize.width / 2;

    CTLineRef line = CTLineCreateWithAttributedString(
            (__bridge CFAttributedStringRef)stringToDraw);
    CGContextSetTextPosition(ctx, midWidth, 13);
    CTLineDraw(line, ctx);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

@end
