#import <UIKit/UIKit.h>
#import "LCategory.h"

//	TODO: split into multiple files

@interface UIAlertView (LCategory)
+ (void)show_title:(NSString*)title;
+ (void)show_title:(NSString*)title message:(NSString*)message;
@end
