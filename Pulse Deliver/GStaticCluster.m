#import "GStaticCluster.h"
#import "GQuadItem.h"

@implementation GStaticCluster {
    CLLocationCoordinate2D _position;
    NSMutableSet *_items;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate andMarker:(GMSMarker *)marker{
    if (self = [super init]) {
        _position = coordinate;
        _items = [[NSMutableSet alloc] init];
        _marker = marker;
    }
    return self;
}

- (NSString *) getUsernames
{
    NSString *list = @"";
    for (GQuadItem *item in _items)
    {
        if (list.length > 0)
            list = [NSString stringWithFormat:@"%@;%@", list, item.username];
        else
            list = item.username;
    }
    return list;
}

- (void)reset
{
    self.username = [self getUsernames];
}

- (void)add:(GQuadItem*)item {
    [_items addObject:item];
    [self reset];
}

- (void)remove:(GQuadItem*)item {
    [_items removeObject:item];
    [self reset];
}
- (NSSet*)items {
    return _items;
}

- (CLLocationCoordinate2D)position {
    return _position;
}

@end
