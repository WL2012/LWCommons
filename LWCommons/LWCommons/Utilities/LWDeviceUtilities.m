//
//  LWDeviceUtilities.m
//  
//
//  Created by chris on 6/19/14.
//  Copyright (c) 2014 wangliang. All rights reserved.
//

#import "LWDeviceUtilities.h"
#import <UIKit/UIKit.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <AdSupport/ASIdentifierManager.h>
#import <sys/utsname.h>
#import "NSString+Utilities.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation LWDeviceUtilities
static LWDeviceUtilities * _sharedInstance = nil;

+ (LWDeviceUtilities*)sharedInstance {
    @synchronized([LWDeviceUtilities class]) {
        if(!_sharedInstance)
            _sharedInstance = [[self alloc] init];
        return _sharedInstance;
    }
    return nil;
}

+ (id)alloc {
    @synchronized([LWDeviceUtilities class]) {
		NSAssert(_sharedInstance == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedInstance = [super alloc];
		return _sharedInstance;
	}
	return nil;
}

- (NSString*)getDeviceUid {
    if(!_deviceUid){
        _deviceUid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    return _deviceUid;
}

- (NSString*)getDeviceName {
    return [SDiOSVersion deviceNameString];
}

- (NSString*)getModel {
    return [[UIDevice currentDevice] model];
}

- (NSString*)getIMEI{
    if(!_imei){
//        extern CFStringRef kLockdownIMEIKey;
//        void* connection = lockdown_connect();
//        _imei = [(NSString*)lockdown_copy_value(connection, NULL, kLockdownIMEIKey) autorelease];
//        lockdown_disconnect(connection);
        _imei = @"";
    }
    return _imei;
}

- (NSString*)getSystemVersion {
    if(!_systemVersion){
        _systemVersion = [[UIDevice currentDevice] systemVersion];
    }
    return _systemVersion;
}

- (NSString*)getSystemName {
    return [[UIDevice currentDevice] systemName];
}

- (NSInteger)getSystemMajorVersion {
    return [[self getSystemVersion] doubleValue];
}

- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

-(NSString*)getCellularProviderName {
    if (!_cellularProviderName) {
        CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc]init];
        
        CTCarrier*carrier = [netInfo subscriberCellularProvider];
        if (carrier!=NULL) {
//            NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
//            [dic setObject:[carrier carrierName] forKey:@"Carriername"];
//            [dic setObject:[carrier mobileCountryCode] forKey:@"MobileCountryCode"];
//            [dic setObject:[carrier mobileNetworkCode]forKey:@"MobileNetworkCode"];
//            [dic setObject:[carrier isoCountryCode] forKey:@"ISOCountryCode"];
//            [dic setObject:[carrier allowsVOIP]?@"YES":@"NO" forKey:@"AllowsVOIP"];
            _cellularProviderName = [carrier carrierName];
        }
    }
    return [NSString isNullOrEmpty:_cellularProviderName]? @"" : _cellularProviderName;
    
}

- (BOOL)limitAdTracking {
    return [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled];
}

- (BOOL)iPhoneX {
    DeviceVersion deviceVersion = [SDiOSVersion deviceVersion];
    DeviceSize deviceSize = [SDiOSVersion deviceSize];
    if(deviceVersion == iPhoneX || deviceSize == Screen5Dot8inch) {
        return YES;
    }
    return NO;
}

- (BOOL)iPhonePlus {
    DeviceVersion deviceVersion = [SDiOSVersion deviceVersion];
    DeviceSize deviceSize = [SDiOSVersion deviceSize];
    if(deviceVersion==iPhone6Plus || deviceVersion==iPhone6SPlus || deviceVersion == iPhone7Plus || deviceSize==Screen5Dot5inch){
        return YES;
    }
    return NO;
}

- (BOOL)iPhone6 {
    DeviceVersion deviceVersion = [SDiOSVersion deviceVersion];
    DeviceSize deviceSize = [SDiOSVersion deviceSize];
    if(deviceVersion==iPhone6 || deviceVersion==iPhone6S || deviceVersion == iPhone7 || deviceSize==Screen4Dot7inch){
        return YES;
    }
    return NO;
}

- (BOOL)iPhone5 {
    DeviceVersion deviceVersion = [SDiOSVersion deviceVersion];
    DeviceSize deviceSize = [SDiOSVersion deviceSize];
    if(deviceVersion==iPhone5 || deviceVersion==iPhone5C || deviceVersion==iPhone5S || deviceVersion==iPodTouch5Gen || deviceVersion==iPodTouch6Gen || deviceVersion == iPhoneSE || deviceSize==Screen4inch){
        return YES;
    }
    return NO;
}

- (BOOL)iPhone4 {
    DeviceVersion deviceVersion = [SDiOSVersion deviceVersion];
    DeviceSize deviceSize = [SDiOSVersion deviceSize];
    if(deviceVersion==iPhone4 || deviceVersion==iPhone4S || deviceVersion==iPodTouch3Gen || deviceVersion==iPodTouch4Gen || deviceSize==Screen3Dot5inch){
        return YES;
    }
    return NO;
}

@end
