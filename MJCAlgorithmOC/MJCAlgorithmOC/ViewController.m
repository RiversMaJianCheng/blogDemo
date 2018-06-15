//
//  ViewController.m
//  MJCAlgorithmOC
//
//  Created by 建承 马  on 2018/6/14.
//  Copyright © 2018年 建承 马 . All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //冒泡排序
    NSArray *array = @[@23,@89,@16,@8,@77,@99,@1,@29,@6];
    NSMutableArray *muarray = [NSMutableArray arrayWithArray:array];
    
    //冒泡排序
//    [self sortArray:muarray];
    
    //快速排序
    [self quickArray:muarray];
    
    //堆排序
//  NSArray *array1 =  [self heapSort:muarray];
//    NSLog(@"%@",array1);
}


/**
 冒泡排序
 @param array 传入的要排序的数组参数
 @return 返回排序好的数组参数
 */
- (NSArray *)sortArray:(NSMutableArray *)array{
    for (NSInteger i = 0; i < array.count ; i++) {
        
        //这是每次找到最大值放在最后,相邻两个数据进行比较,这个是冒泡排序
        for (NSInteger j = 0; j < array.count - i - 1; j++) {
            if (array[j] > array[j + 1]) {
                [array exchangeObjectAtIndex:j + 1 withObjectAtIndex:j];
            }
        }
        
        //每次找到最小的放最前,这个是选择排序
        for (NSInteger k = i + 1; k < array.count; k++) {
            if (array[i] > array[k]) {
                [array exchangeObjectAtIndex:i withObjectAtIndex:k];
            }
        }
    }
    NSLog(@"%@",array);
    return array;
}


/**
 快速排序

 @param quickArray 需要传入的数组参数
 @return 返回排序后的数组
 */
- (NSArray *)quickArray:(NSMutableArray *)quickArray{
    [self quickSortArray:quickArray leftIndex:0 rightIndex:quickArray.count - 1];
    NSLog(@"%@",quickArray);
    return quickArray;
}

- (void)quickSortArray:(NSMutableArray *)array leftIndex:(NSInteger)leftIndex rightIndex:(NSInteger)rightIndex{
    if (leftIndex > rightIndex) {
        return;
    }
    NSInteger i = leftIndex, j = rightIndex;
    NSInteger key = [array[leftIndex] integerValue];
 
    while (i < j) {
        
        while ([array[j] integerValue] >= key && i < j) {
            j--;
        }
        while ([array[i] integerValue] <= key && i < j) {
            i++;
        }
        [array exchangeObjectAtIndex:i withObjectAtIndex:j];
    }
    [array exchangeObjectAtIndex:i withObjectAtIndex:leftIndex];
    
    //递归调用
    [self quickSortArray:array leftIndex:leftIndex rightIndex:j - 1];//继续处理左边的，这里是一个递归的过程
    [self quickSortArray:array leftIndex:j + 1 rightIndex:rightIndex];//继续处理右边的 ，这里是一个递归的过程
    
}


/**
 堆排序

 @param mutableArray 传入的可变数组
 @return 返回排序后的数组
 */
- (NSArray *)heapSort:(NSMutableArray *)mutableArray{
    
    NSInteger i, size;
    size = mutableArray.count;
    
    //构造大顶堆,找出最大的元素放到堆顶.最后一个非叶子结点开始
    for (i = mutableArray.count / 2 - 1; i >= 0; i--) {
        [self creatBigHeap:mutableArray withSize:size beIndex:i];
    }
    
    while (size > 0) {
        //将最大与最后一个来交换
        [mutableArray exchangeObjectAtIndex:size-1 withObjectAtIndex:0];
        size--;
        [self creatBigHeap:mutableArray withSize:size beIndex:0];
        
    }
    return mutableArray;
}

- (void)creatBigHeap:(NSMutableArray *)mutableArray withSize:(NSInteger) size beIndex:(NSInteger)beIndex{
    
    //找到左右子树
    NSInteger leftChildIndex = beIndex * 2 + 1, rightChildIndex = leftChildIndex + 1;
    while (rightChildIndex < size) {
        
        //如果节点比左右子树都大,完成遍历整理
        if (mutableArray[beIndex] >= mutableArray[leftChildIndex] && mutableArray[beIndex] >= mutableArray[rightChildIndex]) return;
        
        if (mutableArray[leftChildIndex] > mutableArray[rightChildIndex]) {
            //如果左侧最大,把左侧的叶子结点值赋值给根结点
            [mutableArray exchangeObjectAtIndex:leftChildIndex withObjectAtIndex:beIndex];
            beIndex = leftChildIndex; //循环遍历此结点下的所有子树,这个和下面的配合其实就是向下回溯的过程
        }else{
            [mutableArray exchangeObjectAtIndex:rightChildIndex withObjectAtIndex:beIndex];
            beIndex = rightChildIndex;
        }
        //重新计算子树的位置
        leftChildIndex = beIndex * 2 + 1;
        rightChildIndex = leftChildIndex + 1;
    }
    //只有左子树且子树大于自己
    if (leftChildIndex < size && mutableArray[leftChildIndex] > mutableArray[beIndex]) {
        [mutableArray exchangeObjectAtIndex:leftChildIndex withObjectAtIndex:beIndex];
    }
    
}

@end
