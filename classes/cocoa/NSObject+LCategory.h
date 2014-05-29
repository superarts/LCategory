#import <Foundation/Foundation.h>
#import <objc/runtime.h>
// #include "LYCategory.h"

@interface NSObject (LCategory)

- (id)release_nil;		//	obj = [obj release_nil];

//	safely perform a selector as string
- (id)perform_string:(NSString*)string;
- (id)perform_string:(NSString*)string with:(id)obj;
- (id)perform_string:(NSString*)string with:(id)obj1 with:(id)obj2;

//	safely perform a selector
- (id)perform_selector:(SEL)selector with:(id)obj1 with:(id)obj2;
- (id)perform_selector:(SEL)selector;
- (id)perform_selector:(SEL)selector with:(id)obj;

//	category instance variables
- (void)associate:(NSString*)key with:(id)obj;
- (id)associated:(NSString*)key;

@end
