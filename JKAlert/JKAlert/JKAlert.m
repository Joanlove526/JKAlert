//
//  JKAlert.m
//  JKAlert
//
//  Created by Jakey on 15/1/20.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import "JKAlert.h"
@implementation JKAlertItem
@end
@implementation JKAlert
- (NSInteger)addButtonWithTitle:(NSString *)title{
    [_items addObject:title];
    return [_items indexOfObject:title];
}
- (id)initWithTitle:(NSString *)title andMessage:(NSString *)message{
    self = [super init];
    if (self != nil)
    {
        _items = [[NSMutableArray alloc] init];
        _title  = title;
        _message = message;
    }
    return self;
}
- (void)addButton:(ItemType)type withTitle:(NSString *)title handler:(JKAlertHandler)handler{
    JKAlertItem *item = [[JKAlertItem alloc] init];
    item.title = title;
    item.action = handler;
    item.type = type;
    [_items addObject:item];
    item.tag = [_items indexOfObject:item];
}
-(void)show
{
    
    if (NSClassFromString(@"UIAlertController") != nil)
    {
        [self show8];
    }
    else
    {
        [self show7];
    }
}

-(void)show8
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:_title
                                                                             message:_message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    
    for (JKAlertItem *item in _items)
    {
        UIAlertActionStyle style = UIAlertActionStyleDefault;
        
        if (item.type == ITEM_CANCEL) {
            style = UIAlertActionStyleCancel;
        }
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:item.title style:style handler:^(UIAlertAction *action) {
            item.action(item);
        }];
        
        [alertController addAction:alertAction];

    }
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        UIViewController *top = [UIApplication sharedApplication].keyWindow.rootViewController;
        [top presentViewController:alertController animated:YES completion:nil];
    });
    
}


-(void)show7
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:_title
                                                        message:_message
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil];
    
    for (JKAlertItem *item in _items)
    {
        if (item.type == ITEM_CANCEL)
        {
            [alertView setCancelButtonIndex:[alertView addButtonWithTitle:item.title]];
        }
        else
        {
            [alertView addButtonWithTitle:item.title];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [alertView show];
    });
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    JKAlertItem *item = _items[buttonIndex];
    item.action(item);
}
@end
