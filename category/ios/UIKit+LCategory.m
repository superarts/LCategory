#import "UIKit+LCategory.h"

//	TODO: split into multiple files

@implementation UIAlertView (LCategory)
+ (void)show_title:(NSString*)title
{
	[UIAlertView show_title:title message:nil];
}
+ (void)show_title:(NSString*)title message:(NSString*)message
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message
		delegate:nil cancelButtonTitle:_s_uikit(@"OK") otherButtonTitles:nil];
	[alert show];
}
@end
