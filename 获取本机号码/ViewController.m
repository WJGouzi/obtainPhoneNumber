//
//  ViewController.m
//  获取本机号码
//
//  Created by gouzi on 2017/3/28.
//  Copyright © 2017年 王钧. All rights reserved.
//

#import "ViewController.h"
#import <Contacts/Contacts.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self simMessage];
}


#pragma mark - ==============获取sim卡的相关信息======================
- (void)simMessage {
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = networkInfo.subscriberCellularProvider;
    NSString *carrier_country_code = carrier.isoCountryCode;
    if (carrier_country_code == nil) {
        carrier_country_code = @"";
    }
    //国家编号
    NSString *CountryCode = carrier.mobileCountryCode;
    if (CountryCode == nil) {
        CountryCode = @"";
    }
    NSLog(@"国家编号 = %@",CountryCode);
    //网络供应商编码
    NSString *NetworkCode = carrier.mobileNetworkCode;
    if (NetworkCode == nil) {
        NetworkCode = @"";
    }
    NSLog(@"网络供应商编码 = %@",NetworkCode);
    NSString *mobile_country_code = [NSString stringWithFormat:@"%@%@", CountryCode, NetworkCode];
    if (mobile_country_code == nil) {
        mobile_country_code = @"";
    }
    NSString *carrier_name = nil;    //网络运营商的名字
    NSString *code = [carrier mobileNetworkCode];
    if ([code isEqualToString:@"00"] || [code isEqualToString:@"02"] || [code isEqualToString:@"07"]) {
        //移动
        carrier_name = @"CMCC";
    }
    if ([code isEqualToString:@"03"] || [code isEqualToString:@"05"]) {
        // ret = @"电信";
        carrier_name =  @"CTCC";
    }
    if ([code isEqualToString:@"01"] || [code isEqualToString:@"06"]) {
        // ret = @"联通";
        carrier_name =  @"CUCC";
    }
    if (code == nil) {
        carrier_name = @"";
    }
    carrier_name = [[NSString stringWithFormat:@"%@-%@",carrier_name,carrier.carrierName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


@end
