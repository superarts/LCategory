#import "NSObject+LCategory.h"
#import "UIKit+LCategory.h"

//	TODO: move macros to LFoundation

#ifndef UIKitLocalizedString
#	define UIKitLocalizedString(key)	[[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] localizedStringForKey:key value:@"" table:nil]
#endif

#ifndef _s_uikit
#	define _s_uikit(key)				UIKitLocalizedString(key)
#endif

#ifndef log
#	if DEBUG
#		warning LOGGING ENABLED FOR DEBUG MODE ONLY
#		define log(...)	NSLog(__VA_ARGS__)
//		define log(fmt, ...) NSLog((@"%s " fmt), __PRETTY_FUNCTION__, ##__VA_ARGS__)
#	else
#		define log(...)
#	endif
#endif

#ifndef UIColorFromRGB
#	define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#endif

#define k_lf_animation_duration_short	0.3
#define k_lf_animation_duration_medium	0.5
#define k_lf_animation_duration_long	0.7
