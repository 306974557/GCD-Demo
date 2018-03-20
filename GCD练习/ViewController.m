//
//  ViewController.m
//  GCD练习
//
//  Created by apple on 2018/3/19.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, assign) NSInteger ticketCount;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self syncConcurrent];//同步并发
//    [self asyncConcurrent];//异步并发
//    [self syncSerial];//同步串行
//    [self asyncSerial];//异步串行
//    [self syncMain];//同步主队列
//    [NSThread detachNewThreadSelector:@selector(syncMain) toTarget:self withObject:nil];//创建线程执行syncMain
//    [self asyncMain];//异步主队列
//    [self communication];//线程间通信
//    [self barrier];//栅栏方法
//    [self after];//延迟执行
//    [self once];//只执行一次
//    [self apply];//快速迭代方法
//    [self groupNotify];//队列组
//    [self groupWait];//dispatch_group_wait
//    [self groupEnterAndLeave];
//    [self initTicketStatusSave];//通过信号量计数确保线程安全
}

/**
 同步执行 + 并发队列
 特点：在当前线程中执行任务，不会开启新线程，执行完一个任务，再执行下一个任务
 */
- (void)syncConcurrent {
    
    NSLog(@"currentThread--%@", [NSThread currentThread]);
    NSLog(@"syncConcurrent--begin");
    
    dispatch_queue_t queue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue, ^{
       //任务1
        for (int i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@",[NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        //任务2
        for (int i = 0; i < 3; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2---%@", [NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        //任务3
        for (int i = 0; i < 4; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3---%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"syncConcurrent--end");
}

/**
 异步执行 + 并发队列
 特点：可以开启多个线程，任务交替（同时）执行
 */
- (void)asyncConcurrent {
    NSLog(@"currentThread--%@",[NSThread currentThread]);
    NSLog(@"asyncConcurrent--begin");
    
    dispatch_queue_t queue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
       //任务1
        for (int i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1--%@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        //任务2
        for (int i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2--%@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        //任务3
        for (int i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3--%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"asyncConcurrent--end");
}


/**
 同步执行 + 串行队列
 特点：不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务才会去执行下一个任务
 */
- (void)syncSerial{
    NSLog(@"currentThread--%@",[NSThread currentThread]);
    NSLog(@"syncSerial--begin");
    
    dispatch_queue_t queue = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        //任务1
        for (int i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1--%@",[NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        //任务2
        for (int i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2--%@",[NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        //任务3
        for (int i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3--%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"syncSerial--end");
}

/**
 异步执行 + 串行队列
 特点：会开启新线程，但因为任务是串行的，执行完一个任务才执行下一个任务
 */
- (void)asyncSerial{
    NSLog(@"currentThread--%@",[NSThread currentThread]);
    NSLog(@"syncSerial--begin");
    
    dispatch_queue_t queue = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        //任务1
        for (int i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1--%@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        //任务2
        for (int i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2--%@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        //任务3
        for (int i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3--%@",[NSThread currentThread]);
        }
    });
    NSLog(@"asyncSerial--end");
}

//主队列：GCD自带的一种特殊的串行队列
//所有放在主队列中的任务，都会放在主线程中执行
//可使用dispatch_get_main_queue()获得主队列



/**
 同步执行 + 主队列
 特点（主线程调用）：互相等待不执行，造成死锁
 特点（其他线程调用）：不会开启新线程，执行完一个任务，再执行下一个任务
 */
- (void)syncMain {
    NSLog(@"currentThread--%@",[NSThread currentThread]);
    NSLog(@"syncMain--begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_sync(queue, ^{
        //任务1
        for (int i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1--%@",[NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        //任务2
        for (int i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2--%@",[NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        //任务3
        for (int i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3--%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"syncMain--end");
}

/**
 异步执行 + 主队列
 特点：只在主线程中执行任务，执行完一个任务，再执行下一个任务
 */
- (void)asyncMain {
    NSLog(@"currentThread--%@",[NSThread currentThread]);
    NSLog(@"ayncMain--begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        //任务1
        for (int i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1--%@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        //任务2
        for (int i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2--%@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        //任务3
        for (int i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3--%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"asyncMain--end");
}

#pragma mark GCD线程间的通信

/**
 线程间通信
 */
- (void)communication {

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
       //异步追加任务
        for (int i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@",[NSThread currentThread]);
        }
        
        //回到主线程
        dispatch_async(mainQueue, ^{
           //追加在主线程中执行任务
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2---%@",[NSThread currentThread]);
        });
    });
}

#pragma mark GCD栅栏方法

/**
 栅栏方法
 */
- (void)barrier {
    dispatch_queue_t queue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
       //任务1
        for (int i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        //任务2
        for (int i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2---%@",[NSThread currentThread]);
        }
    });
    
    dispatch_barrier_async(queue, ^{
       //追加任务barrier
        for (int i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"barrier---%@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        //任务3
        for (int i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3---%@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        //任务4
        for (int i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"4---%@",[NSThread currentThread]);
        }
    });
}

#pragma mark 延迟执行方法

/**
 延迟执行方法
 */
- (void)after{
    NSLog(@"currentThread---%@",[NSThread currentThread]);
    NSLog(@"asyncMain---begin");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //2秒后异步追加代码到主队列，并开始执行
        NSLog(@"after---%@",[NSThread currentThread]);
    });
}

#pragma mark GCD一次性（只执行一次）代码

/**
 只执行1次
 */
- (void)once {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       //只执行1次代码（默认是线程安全）
    });
}

#pragma mark GCD快速迭代方法

/**
 快速迭代
 */
- (void)apply {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSLog(@"apply---begin");
    dispatch_apply(6, queue, ^(size_t index) {
        NSLog(@"%zd---%@",index, [NSThread currentThread]);
    });
    NSLog(@"apply---end");
}

#pragma mark 队列组

- (void)groupNotify {
    NSLog(@"currentThread---%@",[NSThread currentThread]);
    NSLog(@"group---begin");
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       //任务1
        for (int i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@",[NSThread currentThread]);
        }
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //任务2
        for (int i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2---%@",[NSThread currentThread]);
        }
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
       
        //等任务1、2完成后回到主线程执行
        for (int i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3---%@",[NSThread currentThread]);
        }
        NSLog(@"group---end");
    });
    
}

#pragma mark dispatch_group_wait

- (void)groupWait {
    NSLog(@"currentThread---%@",[NSThread currentThread]);
    NSLog(@"group---begin");
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //任务1
        for (int i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@",[NSThread currentThread]);
        }
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //任务2
        for (int i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2---%@",[NSThread currentThread]);
        }
    });
    
    //等待上面任务全部完成后，再继续往下执行（会阻塞主线程）
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    NSLog(@"group---end");
}

#pragma mark dispatch_group_enter  dispatch_group_leave

- (void)groupEnterAndLeave {
    NSLog(@"currentThread---%@",[NSThread currentThread]);
    NSLog(@"group---begin");
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        //任务1
        for (int i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@",[NSThread currentThread]);
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        //任务2
        for (int i = 0; i < 2; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2---%@",[NSThread currentThread]);
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            //任务3
            for (int i = 0; i < 2; i ++) {
                [NSThread sleepForTimeInterval:2];
                NSLog(@"3---%@",[NSThread currentThread]);
            }
        NSLog(@"group---end");
    });
}


#pragma mark Dispatch Semphore 线程同步和线程安全（为线程加锁）

- (void)initTicketStatusSave {
    NSLog(@"currentThread---%@",[NSThread currentThread]);
    NSLog(@"semaphore---begin");
    
    dispatch_semaphore_t semaphoreLock = dispatch_semaphore_create(1);
    self.ticketCount = 50;
    
    dispatch_queue_t queue1 = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2 = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL);

    dispatch_async(queue1, ^{
        
        [self saleTicketSafeWithSemaphore:semaphoreLock];
    });
    
    dispatch_async(queue2, ^{
        [self saleTicketSafeWithSemaphore:semaphoreLock];
    });
}

- (void)saleTicketSafeWithSemaphore:(dispatch_semaphore_t)semaphore {

    while (1) {
        //相当于加锁
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);//信号总量-1，为0时等待，阻塞所在线程
        if (self.ticketCount > 0) {
            self.ticketCount --;
            NSLog(@"%@",[NSString stringWithFormat:@"剩余票数：%ld, 窗口：%@", self.ticketCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        }else {
            
            NSLog(@"所有票已售完");
            //相当于解锁
            dispatch_semaphore_signal(semaphore);//让信号总量+1
            break;
        }
        
        //相当于解锁
        dispatch_semaphore_signal(semaphore);//让信号总量+1
    }
}

@end
