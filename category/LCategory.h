#import "NSObject+LCategory.h"
#import "UIKit+LCategory.h"

//	TODO: move macros to LFoundation
#define UIKitLocalizedString(key)	[[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] localizedStringForKey:key value:@"" table:nil]
#define _s_uikit(key)				UIKitLocalizedString(key)

#ifndef log
#	if DEBUG
#		warning LOGGING ENABLED FOR DEBUG MODE ONLY
#		define log(...)	NSLog(__VA_ARGS__)
//		define log(fmt, ...) NSLog((@"%s " fmt), __PRETTY_FUNCTION__, ##__VA_ARGS__)
#	else
#		define log(...)
#	endif
#endif
