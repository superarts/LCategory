#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "LCategory.h"

//	TODO: split into different files


@interface NSObject (LCategory)

//	- (id)release_nil;		//	obj = [obj release_nil];	XXX: switching to ARC

//	safely perform a selector as string
- (void)perform_string:(NSString*)string;
- (void)perform_string:(NSString*)string with:(id)obj;
- (void)perform_string:(NSString*)string with:(id)obj1 with:(id)obj2;

//	safely perform a selector
- (void)perform_selector:(SEL)selector with:(id)obj1 with:(id)obj2;
- (void)perform_selector:(SEL)selector;
- (void)perform_selector:(SEL)selector with:(id)obj;

//	category instance variables
- (void)associate:(NSString*)key with:(id)obj;
- (id)associated:(NSString*)key;

@end


@interface NSString (lc_defaults)

- (BOOL)default_bool;
- (NSInteger)default_integer;
- (NSString*)default_string;
- (id)default_obj;
- (id)default_object;
- (void)default_bool:(BOOL)b;
- (void)default_integer:(NSInteger)i;
- (void)default_string:(NSString*)s;
- (void)default_obj:(NSObject*)obj;
- (void)default_object:(id)obj;

@end


@interface NSString (lc_expression)

- (NSString*)url_to_filename;
- (NSString*)to_url;
- (NSString*)escape;
- (BOOL)is_email;
- (BOOL)is_english_name;

@end
