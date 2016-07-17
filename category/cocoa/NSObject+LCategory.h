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
- (int)default_int;
- (NSString*)default_string;
- (id)default_obj;
- (id)default_object;
- (void)default_bool:(BOOL)b;
- (void)default_integer:(NSInteger)i;
- (void)default_int:(int)i;
- (int)default_int_inc;
- (int)default_int_dec;
- (int)default_int_inc:(int)integer;
- (int)default_int_dec:(int)integer;
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


@interface NSString (lc_string)

- (BOOL)is:(NSString*)s;
- (BOOL)contains:(NSString*)sub;
- (NSString*)string_without_leading_space;
- (NSString*)string_replace:(NSString*)substring with:(NSString*)replacement;
- (NSString*)string_without:(NSString*)head to:(NSString*)tail;
- (NSString*)string_without:(NSString*)head to:(NSString*)tail except:(NSArray*)exceptions;
- (NSString*)string_between:(NSString*)head and:(NSString*)tail;
- (NSString*)string_between:(NSString*)head and:(NSString*)tail from:(int)index;
- (NSArray*)array_between:(NSString*)head and:(NSString*)tail;
- (BOOL)is_hashtag;
- (NSArray*)array_hashtag;
+ (NSString*)string_from_int:(int)i;
#if 0
- (NSString*)s_int:(int)i;				//	[@"photo" s_int:3] == @"3 photos"
- (NSString*)s_int_with_no:(int)i;
- (NSString*)s_int_with_No:(int)i;
#endif
- (NSString*)append_line:(NSString*)str;
- (NSString*)append_line2:(NSString*)str;
- (NSString*)append:(NSString*)str divider:(NSString*)divider;
- (NSString*)capitalize_first;

@end


@interface NSString (lc_file)

- (NSString*)filename_document;
- (NSString*)filename_documents;
- (NSString*)filename_library;
- (NSString*)filename_private:(NSString*)dir;
- (NSString*)filename_private;
- (NSString*)filename_bundle;
- (BOOL)is_directory;
- (BOOL)file_exists;
- (BOOL)file_exists_documents;
- (BOOL)file_exists_bundle;
- (BOOL)file_exists_absolute;
- (BOOL)create_dir_absolute;
- (BOOL)create_dir;
- (BOOL)file_remove;
- (BOOL)file_backup;
- (void)delete_files:(NSString*)keyword day:(int)day;
- (void)delete_files:(NSString*)keyword second:(int)second;

@end


@interface NSNotificationCenter (lc_unique_notification)

- (void)add_observer_unique:(id)observer selector:(SEL)selector name:(NSString *)name object:(id)object;

@end