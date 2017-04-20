//
//  WXPayCheckModel.h
//  LaundrySheet
//
//  Created by 宇玄丶 on 2017/3/1.
//  Copyright © 2016年 北京116工作室. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXPayCheckModel : NSObject
//应用ID
@property(nonatomic,copy)NSString *appid;
//随机字符串
@property(nonatomic,copy)NSString *noncestr;
//扩展字段
@property(nonatomic,copy)NSString *package;
//商户号
@property(nonatomic,copy)NSString *partnerid;
//预支付交易会话ID
@property(nonatomic,copy)NSString *prepayid;
//签名
@property(nonatomic,copy)NSString *sign;
//时间戳
@property(nonatomic,copy)NSString *timestamp;

//支付方式
@property(nonatomic,copy)NSString *payMothed;

@end
