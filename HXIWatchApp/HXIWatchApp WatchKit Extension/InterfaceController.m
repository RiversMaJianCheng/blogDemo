//
//  InterfaceController.m
//  HXIWatchApp WatchKit Extension
//
//  Created by 建承 马  on 2018/7/4.
//  Copyright © 2018年 建承 马 . All rights reserved.
//

#import "InterfaceController.h"
#import <WatchConnectivity/WatchConnectivity.h>

@interface InterfaceController ()<WCSessionDelegate>

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    // Configure interface objects here.
}
- (void)willActivate {
    [super willActivate];
    if([WCSession isSupported]){
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
}

- (void)didDeactivate {
    [super didDeactivate];
}

- (IBAction)InvestButton {
    [self pushControllerWithName:@"HXInvestInterfaceController" context:nil];
}

- (IBAction)signButton {
    [self pushControllerWithName:@"HXSignInterfaceController" context:nil];
}

#pragma mark =====delegate =======
//收到消息代理方法
-(void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString     *,id> *)message replyHandler:(void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *msg=[NSString stringWithFormat:@"%@",[message valueForKey:@"iOS"]];
        [self.labelMoney setText: msg];
        //向iPhone发送回复消息，代码块参数不能为nil
        NSString *string = [NSString stringWithFormat:@"接收从iWatch发送数据成功-%@-",msg];
        [session sendMessage:@{@"watch":string}    replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
        } errorHandler:^(NSError * _Nonnull error) {
        }];
    });
    
    if (replyHandler) {
        replyHandler(@{@"WATCH":@"WATCH"});
    }
}
-(void)session:(WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(NSError *)error
{
    
}
@end



