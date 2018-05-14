//
//  ViewController.m
//  JCRuntimeDemo
//
//  Created by 建承 马  on 2018/5/14.
//  Copyright © 2018年 建承 马 . All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "SecondStepForward.h"
#import "ThirdStepForward.h"


@interface ViewController ()

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];

    [self performSelector:@selector(xiaomage)];
}

void xiaomageMethod(id obj, SEL _cmd){
    NSLog(@"我消息转发了第一个过程");
}


+ (BOOL)resolveInstanceMethod:(SEL)sel{
    
    //模拟第一个流程
    /*
    //如果是执行foo函数，就动态解析，指定新的IMP
    if (sel == @selector(xiaomage)) {
        class_addMethod([self class], sel, (IMP)xiaomageMethod, "v@");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
    */
    
    //若未在第一步实现，模拟第二个转发流程
    return YES;//return NO 一样效果
}

- (id)forwardingTargetForSelector:(SEL)aSelector{
    
    //模拟第二步消息转发流程
    
    /*
    SecondStepForward *secondStep = [[SecondStepForward alloc] init];
    if ([secondStep respondsToSelector:aSelector]) {
        return secondStep;
        }
    return [super forwardingTargetForSelector:aSelector];
     */
    
    //模拟第三步消息转发流程
    return nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    
    NSMethodSignature *signature =  [super methodSignatureForSelector:aSelector];
    if (!signature) {
        if ([ThirdStepForward instancesRespondToSelector:aSelector]) {
            signature = [ThirdStepForward instanceMethodSignatureForSelector:aSelector];
        }
    }
     return signature;
    //下面这种方式也可以
   /*
    if (aSelector == @selector(xiaomage)) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];////签名，进入forwardInvocation
    }
    */
   
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
    NSLog(@"anInvocation = %@",anInvocation.target);
    SEL sel = anInvocation.selector;
    
    if ([ThirdStepForward instancesRespondToSelector:sel]) {
        [anInvocation invokeWithTarget:[[ThirdStepForward alloc] init]];
    }else{
        [self doesNotRecognizeSelector:sel];
    }
    
    //下面方法也可以
    /*
    ThirdStepForward *thirdStep = [[ThirdStepForward alloc] init];
    if ([thirdStep respondsToSelector:sel]) {
        [anInvocation invokeWithTarget:thirdStep];
    }else{
        [self doesNotRecognizeSelector:sel];
    }
     */
}

@end
