#import "NSObject+LCategory.h"
#import "UIKit+LCategory.h"

//	TODO: move macros to LFoundation
#define UIKitLocalizedString(key)	[[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] localizedStringForKey:key value:@"" table:nil]
#define _s_uikit(key)				UIKitLocalizedString(key)
