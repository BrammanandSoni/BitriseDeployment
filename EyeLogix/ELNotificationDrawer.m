//
//  ELNotificationDrawer.m
//  EyeLogix
//
//  Created by Ashwani Hundwani on 30/08/16.
//  Copyright © 2016 Smriti. All rights reserved.
//

#import "ELNotificationDrawer.h"
#import "AppDelegate.h"


@interface ELNotificationDrawer()

@property(nonatomic, weak)IBOutlet UILabel *lblMessage;
@property(nonatomic, weak)IBOutlet UIView *containerView;
@property(nonatomic, weak)id<ELNotificationDrawerDelegate> delegate;

@end

@implementation ELNotificationDrawer


-(void)awakeFromNib {
    
    [super awakeFromNib];
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowPath = shadowPath.CGPath;
    
    self.containerView.layer.cornerRadius = self.containerView.frame.size.width / 2;
    self.containerView.layer.masksToBounds = YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(void)showNotification:(NSDictionary *)notification
               delegate:(id<ELNotificationDrawerDelegate>)delegate
{
    ELNotificationDrawer *drawer = [[NSBundle mainBundle] loadNibNamed:@"ELNotificationDrawer" owner:self options:nil].lastObject;
    
    drawer.delegate = delegate;
    
    drawer.notification = notification;

    AppDelegate *appDel = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    UIWindow *window = [appDel window];
    window.hidden = NO;
    
    drawer.frame = CGRectMake(10, 20, window.frame.size.width - 20, 80);
    
    [window addSubview:drawer];
    
    [drawer showDrawer];
    
}

-(void)hideDrawer {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = self.frame;
        frame.origin.y = -90;
        self.frame = frame;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
        
    }];
}

-(void)showDrawer {
    
    self.lblMessage.text = self.notification[@"aps"][@"alert"];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = self.frame;
        frame.origin.y = 20;
        self.frame = frame;
        
    } completion:^(BOOL finished) {
        
       // [self performSelector:@selector(hideDrawer) withObject:nil afterDelay:5];
        
    }];
    
    
}

//MARK : Action Methods
-(IBAction)closeTapped:(id)sender {
    
    [self removeFromSuperview];
}

-(IBAction)viewTapped:(id)sender {
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didTapView:)]) {
        
        [self.delegate didTapView:self];
        //[self removeFromSuperview];
    }
}



@end
