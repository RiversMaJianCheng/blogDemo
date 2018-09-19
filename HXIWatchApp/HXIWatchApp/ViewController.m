//
//  ViewController.m
//  HXIWatchApp
//
//  Created by 建承 马  on 2018/7/4.
//  Copyright © 2018年 建承 马 . All rights reserved.
//

#import "ViewController.h"
#import <WatchConnectivity/WatchConnectivity.h>

@interface ViewController ()<WCSessionDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelMsg;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([WCSession isSupported]){
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
}

- (IBAction)clickButton:(UIButton *)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
            int i = arc4random() % 100;
            NSString *string = [NSString stringWithFormat:@"%.2f", 8 + (i / 100.f)];
            //发送消息给iWatch
            [[WCSession defaultSession]sendMessage:@{@"iOS":string} replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
            } errorHandler:^(NSError * _Nonnull error) {
            }];
    });
    

}
-(void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message replyHandler:(void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler
{
    NSString *msg=[NSString stringWithFormat:@"%@",[message valueForKey:@"watch"]];
    self.labelMsg.text = msg;
      NSLog(@"%@",message[@"watch"]);
    if (replyHandler) {
        replyHandler(@{@"IOS":@"IOS"});
    }
}

-(void)session:(WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(NSError *)error
{
    
}
-(void)sessionDidDeactivate:(WCSession *)session
{
    
}
-(void)sessionDidBecomeInactive:(WCSession *)session
{
    
}



@end
