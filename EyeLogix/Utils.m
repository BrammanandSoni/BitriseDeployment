//
//  Utils.m
//  EyeLogix
//
//  Created by Brammanand Soni on 7/13/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "Utils.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"

@implementation Utils

+ (AppDelegate *)appDelegate
{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

+ (NSString *)iOSVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString *)deviceModel
{
    return [[UIDevice currentDevice] model];
}

+ (NSString *)getDocumentDirectoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

+ (NSString *)getGalleryDirectoryPath
{
    NSString *dirPath = [[self getDocumentDirectoryPath] stringByAppendingPathComponent:@"/Images"];
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:dirPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    return dirPath;
}

+ (BOOL)deleteFileFromPath:(NSString *)path
{
    NSError *error;
    return [[NSFileManager defaultManager] removeItemAtPath:path error:&error];;
}

+(void)showProgressInView:(UIView *)view text:(NSString *)text
{
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:view animated:YES];
    progress.labelText = text;
    progress.labelColor = [UIColor whiteColor];
    progress.activityIndicatorColor = [UIColor whiteColor];
    progress.opacity = 0.8;
}

+(void)hideProgressInView:(UIView *)view
{
    [MBProgressHUD hideHUDForView:view animated:YES];
}

+(void)showToastWithMessage:(NSString *)message
{
    AppDelegate *appDel = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.messageFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0];
    style.messageColor = [UIColor whiteColor];
    style.messageAlignment = NSTextAlignmentCenter;
    style.backgroundColor = [UIColor colorWithRed:192.0/255.0 green:7.0/255.0 blue:24.0/255.0 alpha:1.0];
    
    [appDel.window makeToast:message duration:1.0 position:CSToastPositionCenter style:style];
}

+ (void)showAlertInController:(UIViewController *)controller withTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray<NSString *> *)buttonTitles withCompletionBlock:(void (^)(NSInteger clickedIndex))block
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    for (NSString *buttonTitle in buttonTitles) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (block) {
                block([buttonTitles indexOfObject:buttonTitle]);
            }
        }];
        [alertController addAction:action];
    }
    
    [controller presentViewController:alertController animated:NO completion:nil];
}

+ (void)addTapGestureToView:(UIView *)view target:(id)target selector:(SEL)selector
{
    view.userInteractionEnabled = true;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:target action:selector];
    tap.numberOfTapsRequired = 1;
    
    [view addGestureRecognizer:tap];
}

+ (NSString *)getUserName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"];
}

+ (NSString *)getProfileId
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"ProfileId"];
}

+ (NSString *)getToken
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"Token"];
}

+(NSString *)stringFromDate:(NSDate *)date inFormat:(NSString *)strFormat
{
    NSString *strDate = nil;
    static NSDateFormatter *pDateFormatter = nil;
    
    if (!pDateFormatter) {
        pDateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [pDateFormatter setLocale:usLocale];
    }
    
    if (date && strFormat) {
        [pDateFormatter setDateFormat:strFormat];
        strDate = [pDateFormatter stringFromDate:date];
    }
    
    return strDate;
}

+ (NSArray *)getArrayFromDictionary:(NSDictionary *)dict
{
    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *allKeys = [dict allKeys];
    for (int index = 0; index < allKeys.count; index++) {
        id object = [dict objectForKey:[NSString stringWithFormat:@"%d", index]];
        if (object) {
            [array addObject:object];
        }
    }
    
    return array;
}

+ (UIView *)getCustomButtonWithImage:(UIImage *)image selector:(SEL)selector target:(id)target andSize:(CGSize)size
{
    UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:view.bounds];
    imageView.image = image;
    
    [view addSubview:imageView];
    
    UITapGestureRecognizer *menuTapped = [[UITapGestureRecognizer alloc] init];
    [menuTapped addTarget:target action:selector];
    [view addGestureRecognizer:menuTapped];
    
    return view;
}

+(UIFont *)helveticaFontWithSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"HelveticaNeue" size:fontSize];
}

+ (UIViewController *)getViewControllerWithIdentifier:(NSString *)identifier
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [mainStoryBoard instantiateViewControllerWithIdentifier:identifier];
}

+ (NSArray *)dvrCategoryList
{
    return @[@"None", @"Retail Store", @"Gas Station", @"Grocery Shop"];
}

+ (NSArray *)getUserTypeList
{
    return @[@"MANAGER", @"OPERATOR", @"VIEWER"];
}

+ (NSArray *)getCountryList
{
    return @[@"India", @"USA", @"China"];
}

+ (NSArray *)getTimeZoneList
{
    return @[@"GMT+00:00", @"GMT+01:00", @"GMT+02:00", @"GMT+03:00", @"GMT+04:00", @"GMT+05:00", @"GMT+06:00", @"GMT+07:00", @"GMT+08:00", @"GMT+09:00", @"GMT+10:00", @"GMT+11:00", @"GMT+12:00", @"GMT+13:00", @"GMT-01:00", @"GMT-02:00", @"GMT-03:00", @"GMT-04:00", @"GMT-05:00", @"GMT-06:00", @"GMT-07:00", @"GMT-08:00", @"GMT-09:00", @"GMT-10:00", @"GMT-11:00", @"GMT-12:00"];
}

+ (NSArray *)getAccessTypeList
{
    return @[@"ALL", @"ALL/Except Blocked IP", @"Onlu IP"];
}

#pragma mark - UserDefaults

+ (NSUserDefaults *)userDefaults
{
    return [NSUserDefaults standardUserDefaults];
}

+ (void)setDeviceToken:(NSString *)deviceToken
{
    if (!deviceToken) {
        return;
    }
    
    [[self userDefaults] setObject:deviceToken forKey:@"devicetoken"];
}

+ (NSString *)getDeviceToken
{
    return [[self userDefaults] objectForKey:@"devicetoken"];
}

+ (void)setAutoLoginFlag:(BOOL)flag
{
    [[self userDefaults] setBool:flag forKey:@"autoLoginEnabled"];
}

+ (BOOL)getAutoLoginFlag
{
    return [[self userDefaults] boolForKey:@"autoLoginEnabled"];
}

+ (void)setRememberMeFlag:(BOOL)flag
{
    [[self userDefaults] setBool:flag forKey:@"rememberMe"];
}

+ (BOOL)getRememberMeFlag
{
    return [[self userDefaults] boolForKey:@"rememberMe"];
}

+ (void)savePassword:(NSString *)password
{
    if (!password) {
        return;
    }
    
    [[self userDefaults] setObject:password forKey:@"password"];
}

+ (NSString *)getPassword
{
    return [[self userDefaults] objectForKey:@"password"];
}

+ (void)removePassword
{
    [[self userDefaults] removeObjectForKey:@"password"];
}

@end
