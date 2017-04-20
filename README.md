# PayTypeDemo
iOS-集成微信、支付宝支付工具类（使用起来超级简单）

在项目中，我们会经常用到微信支付或者支付宝支付，每次集成就显得麻烦了，所以、我封装了一个工具类，每次选择支付方式的时候只需要调用这个类就可以了。
效果如图所示：

![选择支付方式](http://upload-images.jianshu.io/upload_images/5684426-eaf28ad9ea1d6615.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

使用工具类的方法：
```
/**
       order_id : 一般在做支付的情况下都是传一个order_id
       type     : 如图所示，有两种常用的支付方式,"微信支付"、"支付宝支付"，因为接口给的是上传的参数需要type，所以这么写的，根据自己需求改一改即可。
     */
    [[AppPay sharedInstance] payWithOrderId:self.order_id type:self.selectedPaymentIndex+1  payFinishBlock:^{
        NSLog(@"%ld",(long)self.selectedPaymentIndex+1);
    }];
```
这样一来，就可以随时拿来用了，很方便。

下面来看看我是如何写的这个工具类：
AppPay.h
```
#import <Foundation/Foundation.h>
// 导入微信、支付宝支付的头文件
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>

@interface AppPay : NSObject <WXApiDelegate>
// 创建一个单例
+ (instancetype)sharedInstance;
// 调用方法，传入order_id，支付方式type（可以根据自己的需求做改动）
- (void)payWithOrderId:(NSString *)orderId type:(NSInteger )type payFinishBlock:(void (^)())payFinishBlock;
@end
```
</br>
AppPay.m
```
@interface AppPay ()
//发起的支付请求接口，改成自己的
//@property(nonatomic,strong)OrderPayRequest *orderPayRequest;
@property(nonatomic,strong)NSString *orderId;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,copy)void(^payFinishBlock)();
@end
```

单例
```
+ (instancetype)sharedInstance {
    static AppPay *sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        // 在这里写了个通知，可以把支付成功、失败写在这里，或者看下文，总之，根据需求做修改。
//        [[NSNotificationCenter defaultCenter] addObserver:sharedInstance selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    });
    return sharedInstance;
}
```
pragma mark - 创建支付方式的方法
```
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
    // Github：[iOS-AFNetworking网络层封装设计方案](https://github.com/Baiyongyu/iOS-AFNetworking-.git)
    
//    [self.orderPayRequest loadDataWithHUDOnView:mainWindow()];
}
```
pragma mark - 发起请求需要上传的参数
```
#pragma mark - APIManagerParamSourceDelegate
//- (NSDictionary *)paramsForApi:(BaseAPIRequest *)request {
//    if (request == self.orderPayRequest) {

            // 再Controller里面已经说过：我这个项目的接口需要请求的参数是orderid，还有请求方式type，根据自己的需求修改即可。
//        return @{@"order_id":self.orderId,
//                 @"type":@(self.type)};
//    }
//    return nil;
//}
```
pragma mark - 发起请求 成功之后的回调， 因为要调起微信或者支付宝，需要在请求成功之后再做处理
```
#pragma mark - APIManagerApiCallBackDelegate
- (void)managerCallAPIDidSuccess:(BaseAPIRequest *)request {
    if (request==self.orderPayRequest) {
        if (self.type == 1) {
            
            // 这是方式1：所以判断当type为1的时候支付方式是支付宝支付
 
            // 此处为发起请求之后接口返回的数据，（一个对象），
            WXPayCheckModel *PayData = [request.responseData valueForKey:@"data"];
            
 
            // 此处为调起支付宝支付的单例。
            
            // PayData.sign: 此处为sign签名，就是支付宝那一大堆的参数拼接，因为后台处理好了，就免去了前端的操作，这里只需要写上后台返回好的数据即可。
            // fromScheme: 这里就是在info.plist里面设置的URLScheme：随便设置，只要一致就好了。
             
            // 注意：如果后台返回的不是拼接好的，那么久需要自己去拼接了，就是文档那一大坨，搬过来就行。
  
            [[AlipaySDK defaultService] payOrder:PayData.sign fromScheme:@"alisdkpayfuck" callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
                
                // 接下来就是对支付之后的状态的操作处理了。
                NSInteger orderState = [resultDic[@"resultStatus"] intValue];
                if (orderState == 9000) {  // 支付成功
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
            // 这是方式2：所以判断当type为2的时候支付方式是微信支付
            // 此处为发起请求之后接口返回的数据，（一个对象），
            WXPayCheckModel *PayData = [request.responseData valueForKey:@"data"];
 
            // 将这些数据赋值给微信支付需要传的那几个(集成微信支付需要的赋值操作)
            [self wxPay:PayData];
        }
    }
}
```
pragma mark - 发起支付请求失败的操作
```
- (void)managerCallAPIDidFailed:(BaseAPIRequest *)request {
    [MBProgressHUD showMsgHUD:@"支付失败"];

    OrderPayViewController *payVC = [[OrderPayViewController alloc] init];
    [AppCommon pushViewController:payVC animated:NO];
}
```
#pragma mark - 集成微信SDK需要的东西(也是上文中提到需要赋值的操作)
```
#pragma mark - 微信支付
- (void)wxPay:(WXPayCheckModel *)prepayData {
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = prepayData.partnerid;
    request.prepayId = prepayData.prepayid;
    request.package = prepayData.package;
    request.nonceStr = prepayData.noncestr;
    request.timeStamp = (UInt32)[prepayData.timestamp integerValue];
    request.sign = prepayData.sign;
    
    [WXApi sendReq:request];
}

#pragma mark - 集成微信sdk需要的东西
- (void)onResp:(BaseResp*)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        switch(response.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                [self handelPayResult:YES desp:nil];
                break;
            case WXErrCodeUserCancel:
//                [MBProgressHUD showMsgHUD:@"取消支付" duration:1.0f];
                break;
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                [self handelPayResult:NO desp:resp.errStr];
                break;
        }
    }
}
```
pragma mark - 支付成功失败之后弹出的界面
```
- (void)handelPayResult:(BOOL)success desp:(NSString *)desp {
    if (!success) {
//        PayResultViewController *resultVC = [[PayResultViewController alloc] initWithPayType:kPayDailed order_id:self.orderId];
//        [AppCommon pushViewController:resultVC animated:YES];
    }else {
//        PayResultViewController *resultVC = [[PayResultViewController alloc] initWithPayType:kPaySuccess order_id:self.orderId];
//        [AppCommon pushViewController:resultVC animated:YES];
    }
}
```
pragma mark - 实例化请求方法（这个是个人的网络请求，与demo无关）
```
//- (OrderPayRequest *)orderPayRequest {
//    if (!_orderPayRequest) {
//        _orderPayRequest = [[OrderPayRequest alloc] initWithDelegate:self paramSource:self];
//    }
//    return _orderPayRequest;
//}
```

到此这个工具类就实现了，没有太难的地方，只是简单的封装了起来，有不对，不好的地方欢迎各位大神提出指正。喜欢的小伙伴记得给个Star啊^_^
代码：https://github.com/Baiyongyu/PayTypeDemo.git
