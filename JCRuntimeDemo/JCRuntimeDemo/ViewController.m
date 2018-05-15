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

@property (nonatomic, strong) SecondStepForward *secondStep;
@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.secondStep = [[SecondStepForward alloc] init];
    [self performSelector:@selector(xiaomage)];
}

void xiaomageMethod(id obj, SEL _cmd){
    NSLog(@"我消息转发了第一个过程");
    
    //id 是一个指向类实例的结构体指针
    //typedef struct objc_object *id
    
    //SEL 它是selector在objc中的表示类型，可以理解为区分方法的ID，而这个ID的数据结构是SEL：
    //typedef struct objc_selector *SEL;
    //它是个映射到方法的字符串，可以用objc编译器命令@selector() 或者runtime系统sel_getRegisterNamel 来获得一个SEL类型的方法选择器。
}


+ (BOOL)resolveInstanceMethod:(SEL)sel{
    
    SEL sel1 = sel_registerName("xiaomage");
    if (sel == sel1) {
        NSLog(@"这两个是一样的哈");
    }
    //模拟第一个流程
    /*
     //如果是执行foo函数，就动态解析，指定新的IMP
     if (sel == @selector(xiaomage)) {
     class_addMethod([self class], sel, (IMP)xiaomageMethod, "v@");
     return YES;
     }
     return [super resolveInstanceMethod:sel];
     */
    
    //IMP定义：typedef void (*IMP)(void /* id, SEL, ... */);
    /*
     它是一个函数指针，编译器生成，当发起一个消息是，最终会执行的代码由这个函数指针指定的，而IMP这个函数指针就指向了这个方法的实现。
     既然得到执行某个实例方法的入口，我们就可以绕开消息传递阶段，直接执行方法。
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
    
    //这个也行
    //     return self.secondStep;
    
    //模拟第三步消息转发流程
    return  nil;//这里return self也行，因为会检测是否实现，如果没有实现就相当于nil
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
