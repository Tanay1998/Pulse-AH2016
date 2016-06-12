#import <Foundation/Foundation.h>
#import "GCluster.h"
#import "GQuadItem.h"

@interface GStaticCluster : NSObject <GCluster> 

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate andMarker:(GMSMarker *)marker;

- (void)add:(GQuadItem*)item;
- (void)remove:(GQuadItem*)item;
- (void)reset;
- (NSString *)getUsernames;
@property (nonatomic, strong) GMSMarker *marker;
@property (nonatomic, strong) NSString *username;

@end
