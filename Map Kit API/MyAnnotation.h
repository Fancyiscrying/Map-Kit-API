//
//  MyAnnotation.h
//  Map Kit API
//
//  Created by Fancy on 16/3/2.
//  Copyright © 2016年 Fancy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface MyAnnotation : NSObject<MKAnnotation>


@property (nonatomic,readwrite)CLLocationCoordinate2D coordinate;
@property (nonatomic,copy)NSString *streetAddress;
@property (nonatomic,copy)NSString *city;
@property (nonatomic,copy)NSString *state;
@property (nonatomic,copy)NSString *zip;

@end
