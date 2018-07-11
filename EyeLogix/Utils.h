//
//  Utils.h
//  EyeLogix
//
//  Created by Brammanand Soni on 7/13/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface Utils : NSObject

+ (AppDelegate *)appDelegate;
+ (NSString *)iOSVersion;
+ (NSString *)deviceModel;

+ (NSString *)getGalleryDirectoryPath;
+ (BOOL)deleteFileFromPath:(NSString *)path;

+ (void)showProgressInView:(UIView *)view text:(NSString *)text;
+ (void)hideProgressInView:(UIView *)view;

+ (void)showToastWithMessage:(NSString *)message;
+ (void)showAlertInController:(UIViewController *)controller withTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray<NSString *> *)buttonTitles withCompletionBlock:(void (^)(NSInteger clickedIndex))block;

+ (void)addTapGestureToView:(UIView *)view target:(id)target selector:(SEL)selector;

+ (NSString *)getUserName;
+ (NSString *)getProfileId;
+ (NSString *)getToken;

+ (NSString *)stringFromDate:(NSDate *)date inFormat:(NSString *)strFormat;

+ (NSArray *)getArrayFromDictionary:(NSDictionary *)dict;

+ (UIView *)getCustomButtonWithImage:(UIImage *)image selector:(SEL)selector target:(id)target andSize:(CGSize)size;

+ (UIFont *)helveticaFontWithSize:(CGFloat)fontSize;

+ (UIViewController *)getViewControllerWithIdentifier:(NSString *)identifier;

+ (NSArray *)dvrCategoryList;
+ (NSArray *)getUserTypeList;
+ (NSArray *)getCountryList;
+ (NSArray *)getTimeZoneList;
+ (NSArray *)getAccessTypeList;

#pragma mark - UserDefaults

+ (void)setDeviceToken:(NSString *)deviceToken;
+ (NSString *)getDeviceToken;

+ (void)setAutoLoginFlag:(BOOL)flag;
+ (BOOL)getAutoLoginFlag;

+ (void)setRememberMeFlag:(BOOL)flag;
+ (BOOL)getRememberMeFlag;

+ (void)savePassword:(NSString *)password;
+ (NSString *)getPassword;
+ (void)removePassword;

@end
