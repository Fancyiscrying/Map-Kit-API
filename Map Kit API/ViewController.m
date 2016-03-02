//
//  ViewController.m
//  Map Kit API
//
//  Created by Fancy on 16/3/2.
//  Copyright © 2016年 Fancy. All rights reserved.
//在iOS程序中我们使用Map kit API开发地图应用，器核心时MKMapView 类

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import "MyAnnotation.h"
@interface ViewController ()<UITextFieldDelegate,MKMapViewDelegate,CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtQuerykey;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextView *txtView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong)CLLocation *location;
- (IBAction)geocodeQuery:(id)sender;
- (IBAction)reverseGeocode:(id)sender;
@end

@implementation ViewController


//开始定位服务
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.locationManager startUpdatingLocation];


}
//停止定位服务
- (void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingLocation];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    //定位服务管理对象初始化
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager .desiredAccuracy = kCLLocationAccuracyBest;//精准度
    self.locationManager.distanceFilter = 10.0f;//距离过滤器
    
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    self.txtQuerykey.delegate = self;
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.delegate = self;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)geocodeQuery:(id)sender {
    
    if (_txtQuerykey.text == nil||[_txtQuerykey.text length] ==0) {
        return;
    }
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:_txtQuerykey.text completionHandler:^(NSArray *placemarks,NSError *error)
    {
        NSLog(@"查询纪录数：%lu",[placemarks count]);
        [self.mapView removeAnnotations:self.mapView.annotations];
        
        
        for (int i =0; i <[placemarks count]; i++) {
            CLPlacemark *placemark = placemarks[i];
            
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(placemark.location.coordinate, 10000, 10000);
            [self.mapView setRegion:viewRegion animated:YES];
            MyAnnotation *annotation = [[MyAnnotation alloc] init];
            annotation.streetAddress = placemark.thoroughfare;
            annotation.city = placemark.locality;
            annotation.state = placemark.administrativeArea;
            annotation.zip = placemark.postalCode;
            annotation.coordinate = placemark.location.coordinate;
            [self.mapView addAnnotation:annotation];
            
        }
    
        [_txtQuerykey resignFirstResponder];
        
    }];
    
    
}

- (IBAction)reverseGeocode:(id)sender {
    
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:self.location completionHandler:^(NSArray *placemarks,NSError *error)
    {
    
        if ([placemarks count]>0) {
            CLPlacemark *placemark = placemarks[0];
            NSDictionary *addressDictionary = placemark.addressDictionary;
            NSString *address = [addressDictionary objectForKey:(NSString *)kABPersonAddressStreetKey];
            address = address ==nil?@"":address;
            NSString *state = [addressDictionary objectForKey:(NSString *)kABPersonAddressStateKey];
            state = state ==nil? @"":state;
            NSString *city = [addressDictionary objectForKey:(NSString *)kABPersonAddressCityKey];
            city = city ==nil? @"":city;
            self.txtView.text = [NSString stringWithFormat:@"%@ \n%@\n%@",state,address,city];
        }
    
    
    }];
    
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.txtQuerykey resignFirstResponder];
    
    return YES;


}
- (void)textFieldDidEndEditing:(UITextField *)textField
{

    [self.txtQuerykey resignFirstResponder];

}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{

    _location = [locations lastObject];
    
    NSString *latitude = [NSString stringWithFormat:@"%3.5f",_location.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%3.5f",_location.coordinate.longitude];
    NSString *altitude = [NSString stringWithFormat:@"%3.5f",_location.altitude];
    NSLog(@"经度：%@,纬度：%@,高度：%@",longitude,latitude,altitude);

}

//错误时候的错误信息
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error: %@",error);

}


- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{

    NSLog(@"error : %@",[error description]);

}
@end
