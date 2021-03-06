//
//  AppDelegate.m
//  Passbuster
//
//  Created by Fincher Justin on 15/10/29.
//  Copyright © 2015年 Fincher Justin. All rights reserved.
//

#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#import "AppDelegate.h"
#import "FMDBAPI.h"
#import "FMDB.h"
#import "MainPasswordInput.h"
#import "IntroAnimator.h"

@interface AppDelegate ()

@property (strong,nonatomic)UIImageView *CoverImageView;

@end

@implementation AppDelegate
@synthesize CoverImageView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    FMDBAPI *FMDBAPIInstance = [[FMDBAPI alloc] init];
    [FMDBAPIInstance LaunchCheck];
    //[self IntroCheck];
    
    MainPasswordInput *NewMainPasswordInput =  [[MainPasswordInput alloc] init];
    UITabBarController *TabBarController = (UITabBarController *)self.window.rootViewController;
    [TabBarController.selectedViewController presentViewController:NewMainPasswordInput animated:YES completion:^(void){}];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [self ShowCoverImageView];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self RemoveCoverImageView];
    
    NSString * doc = PATH_OF_DOCUMENT;
    NSString * path = [doc stringByAppendingPathComponent:@"user.sqlite"];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path] == YES)
    {
        FMDatabase * db = [FMDatabase databaseWithPath:path];
        if ([db open])
        {
            int isFirstOpen = [db intForQuery:@"SELECT isFirstOpen FROM AppSettings WHERE id = 1"];
            NSLog(@"isFirstOpen = %d",isFirstOpen);
            if (isFirstOpen == 1)
            {
            }
            else
            {
                NSLog(@"ResignCheck : isFirstOpen = 0");
                
                [db close];
                MainPasswordInput *NewMainPasswordInput =  [[MainPasswordInput alloc] init];
                
                UITabBarController *TabBarController = (UITabBarController *)self.window.rootViewController;
                [TabBarController.selectedViewController presentViewController:NewMainPasswordInput animated:YES completion:^(void){}];

            }
        }
    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)AddCoverImageView
{
    CoverImageView = [[UIImageView alloc] initWithFrame:self.window.frame];
    CoverImageView.image = [UIImage imageNamed:@"LockCover"];
    CoverImageView.contentMode = UIViewContentModeScaleAspectFill;
    CoverImageView.alpha = 0.0f;
    [self.window addSubview:CoverImageView];
}

- (void)ShowCoverImageView
{
    if (!CoverImageView)
    {
        [self AddCoverImageView];
    }
    [UIView animateWithDuration:0.2 animations:^{
        CoverImageView.alpha = 1.0;
    }];
}

- (void)RemoveCoverImageView
{
    if (CoverImageView)
    {
        [UIView animateWithDuration:0.2 animations:^(void)
        {
            CoverImageView.alpha = 0.0f;
        }
                         completion:^(BOOL fininshed)
        {
            [CoverImageView removeFromSuperview];
            CoverImageView = nil;
        }];
    }
}


- (void)IntroCheck
{
    NSString * doc = PATH_OF_DOCUMENT;
    NSString * path = [doc stringByAppendingPathComponent:@"user.sqlite"];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path] == YES)
    {
        FMDatabase * db = [FMDatabase databaseWithPath:path];
        if ([db open])
        {
            int isFirstOpen = [db intForQuery:@"SELECT isFirstOpen FROM AppSettings WHERE id = 1"];
            NSLog(@"isFirstOpen = %d",isFirstOpen);
            if (isFirstOpen == 1)
            {
                NSLog(@"Will go to intro page");
                
                IntroAnimator *IntroAnimatorPage = [[IntroAnimator alloc]init];
                [self.window.rootViewController presentViewController:IntroAnimatorPage animated:YES completion:^(void){}];
            }
            else
            {
                NSLog(@"IntroCheck : isFirstOpen = 0");
                [db close];
            }
        }
    }
}

@end
