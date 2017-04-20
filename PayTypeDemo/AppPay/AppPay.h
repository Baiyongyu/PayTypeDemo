//
//  AppPay.h
//  LaundrySheet
//
//  Created by 宇玄丶 on 2017/3/1.
//  Copyright © 2016年 北京116工作室. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "WXApi.h"
//#import <AlipaySDK/AlipaySDK.h>

@interface AppPay : NSObject
 // <WXApiDelegate>
+ (instancetype)sharedInstance;
- (void)payWithOrderId:(NSString *)orderId type:(NSInteger )type payFinishBlock:(void (^)())payFinishBlock;
@end
