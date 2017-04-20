//
//  AppPay.m
//  LaundrySheet
//
//  Created by 宇玄丶 on 2017/3/1.
//  Copyright © 2016年 北京116工作室. All rights reserved.
//

#import "AppPay.h"
#import "WXPayCheckModel.h"
//#import "OrderPayRequest.h"
//#import "OrderPayViewController.h"
//#import "PayResultViewController.h"

@interface AppPay ()
//发起的支付请求接口，改成自己的
//@property(nonatomic,strong)OrderPayRequest *orderPayRequest;
@property(nonatomic,strong)NSString *orderId;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,copy)void(^payFinishBlock)();
@end

@implementation AppPay

+ (instancetype)sharedInstance {
    static AppPay *sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
//        [[NSNotificationCenter defaultCenter] addObserver:sharedInstance selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    });
    return sharedInstance;
}

- (void)applicationWillEnterForeground:(NSNotification *)notification {

}
#pragma mark - 创建支付方式的方法
- (void)payWithOrderId:(NSString *)orderId type:(NSInteger )type payFinishBlock:(void (^)())payFinishBlock {
    
    if (!orderId.length) {
        if (payFinishBlock) {
            payFinishBlock();
        }
        return;
    }
    self.orderId = orderId;
    self.type = type;
    self.payFinishBlock = payFinishBlock;
    
    // 发起的支付请求接口，改成自己的
    // 如果想了解我使用的框架，请点击这里
    // 简书： http://www.jianshu.com/p/cef11a65e01a
    // Github：https://github.com/Baiyongyu/iOS-AFNetworking-.git
    
//    [self.orderPayRequest loadDataWithHUDOnView:mainWindow()];
}

#pragma mark - 发起请求需要上传的参数

#pragma mark - APIManagerParamSourceDelegate
//- (NSDictionary *)paramsForApi:(BaseAPIRequest *)request {
//    if (request == self.orderPayRequest) {

            // 再Controller里面已经说过：我这个项目的接口需要请求的参数是orderid，还有请求方式type，根据自己的需求修改即可。
//        return @{@"order_id":self.orderId,
//                 @"type":@(self.type)};
//    }
//    return nil;
//}

#pragma mark - 发起请求 成功之后的回调， 因为要调起微信或者支付宝，需要在请求成功之后再做处理

/*
#pragma mark - APIManagerApiCallBackDelegate
- (void)managerCallAPIDidSuccess:(BaseAPIRequest *)request {
    if (request==self.orderPayRequest) {
        if (self.type == 1) {
            
 
            // 这是方式1：所以判断当type为1的时候支付方式是支付宝支付
 
            // 此处为发起请求之后接口返回的数据，（一个对象），
            WXPayCheckModel *PayData = [request.responseData valueForKey:@"data"];
            
 
            // 此处为调起支付宝支付的单例。
            
            // PayData.sign: 此处为sign签名，就是支付宝那一大堆的参数拼接，因为后台处理好了，就免去了前端的操作，这里这需要写上后台返回好的数据即可。
            // fromScheme: 这里就是在info.plist里面设置的URLScheme：随便设置，只要一致就好了。
            
 
            // 注意：如果后台返回的不是拼接好的，那么久需要自己去拼接了，就是文档那一大坨，搬过来就行。
 
 
            [[AlipaySDK defaultService] payOrder:PayData.sign fromScheme:@"alisdkpaywokao" callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
                
                // 接下来就是对支付成功、失败的操作处理了。
                NSInteger orderState = [resultDic[@"resultStatus"] intValue];
                if (orderState == 9000) {
                    [self handelPayResult:YES desp:nil];
                    
                }else{
                    NSString *returnStr;
                    switch (orderState) {
                        case 8000:
                            returnStr = @"订单正在处理中";
                            break;
                        case 4000:
                        {
                            returnStr = @"订单支付失败";
                            [self handelPayResult:NO desp:returnStr];
                            break;
                        }
                        case 6001:
                            returnStr = @"订单取消";
                            break;
                        case 6002:
                            returnStr = @"网络连接出错";
                            break;
                        default:
                            break;
                    }
//                    [MBProgressHUD showMsgHUD:returnStr duration:1.0f];
                }
                
                
            }];
            
        }
        else if (self.type == 2) {
            // 此处为发起请求之后接口返回的数据，（一个对象），
            WXPayCheckModel *PayData = [request.responseData valueForKey:@"data"];
 
            // 将这些数据赋值给微信支付需要传的那几个(143行的方法)
            [self wxPay:PayData];
        }
    }
}

 */

//- (void)managerCallAPIDidFailed:(BaseAPIRequest *)request {
//    [MBProgressHUD showMsgHUD:@"支付失败"];
    //发起支付请求失败的操作
//    OrderPayViewController *payVC = [[OrderPayViewController alloc] init];
//    [AppCommon pushViewController:payVC animated:NO];
//}


#pragma mark - 微信支付
//- (void)wxPay:(WXPayCheckModel *)prepayData {
//    PayReq *request = [[PayReq alloc] init];
//    request.partnerId = prepayData.partnerid;
//    request.prepayId = prepayData.prepayid;
//    request.package = prepayData.package;
//    request.nonceStr = prepayData.noncestr;
//    request.timeStamp = (UInt32)[prepayData.timestamp integerValue];
//    request.sign = prepayData.sign;
//    
//    [WXApi sendReq:request];
//}

#pragma mark - 集成微信sdk需要的东西
//- (void)onResp:(BaseResp*)resp {
//    if ([resp isKindOfClass:[PayResp class]]) {
//        PayResp *response = (PayResp *)resp;
//        switch(response.errCode){
//            case WXSuccess:
//                //服务器端查询支付通知或查询API返回的结果再提示成功
//                NSLog(@"支付成功");
//                [self handelPayResult:YES desp:nil];
//                break;
//            case WXErrCodeUserCancel:
////                [MBProgressHUD showMsgHUD:@"取消支付" duration:1.0f];
//                break;
//            default:
//                NSLog(@"支付失败，retcode=%d",resp.errCode);
//                [self handelPayResult:NO desp:resp.errStr];
//                break;
//        }
//    }
//}

#pragma mark - 支付成功失败之后弹出的界面
- (void)handelPayResult:(BOOL)success desp:(NSString *)desp {
    if (!success) {
//        PayResultViewController *resultVC = [[PayResultViewController alloc] initWithPayType:kPayDailed order_id:self.orderId];
//        [AppCommon pushViewController:resultVC animated:YES];
    }else {
//        PayResultViewController *resultVC = [[PayResultViewController alloc] initWithPayType:kPaySuccess order_id:self.orderId];
//        [AppCommon pushViewController:resultVC animated:YES];
    }
}

#pragma mark - 实例化请求方法（这个是个人的网络请求，与demo无关）
//- (OrderPayRequest *)orderPayRequest {
//    if (!_orderPayRequest) {
//        _orderPayRequest = [[OrderPayRequest alloc] initWithDelegate:self paramSource:self];
//    }
//    return _orderPayRequest;
//}

@end
