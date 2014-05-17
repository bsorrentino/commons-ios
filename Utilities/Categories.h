/*
 * BSC - Bartolomeo Sorrentino Component(s)
 *
 *
 * MACRO TO DEFINE PROPERTIES IN CATEGORY DECLARATION
 *
 * from Stackoverflow
 * http://stackoverflow.com/questions/10502539/objective-c-category-and-new-ivar
 *
 * Macro defines 2 properties implementation with Set and Get prefix so to use them you have to delare a custome getter upon property declaration
 * 
 * Es.
 *
 * In Category header (.h) 
 *
 * @property (nonatomic, getter=getValid) BOOL valid;
 * @property (strong, nonatomic, getter=getPostValidationBlock) PostValidationBlock postValidationBlock;
 * @property (nonatomic, assign, getter=getForwardDelegate) id <UITextFieldDelegate> forwardDelegate;
 *
 * In Category implementation (.m)
 *
 * CATEGORY_PROPERTY_BOOL(Valid); 
 * CATEGORY_PROPERTY2(PostValidationBlock, PostValidationBlock);
 * CATEGORY_PROPERTY2(id<UITextFieldDelegate>, ForwardDelegate);
 */

#ifndef _CATEGORIES_H
#define _CATEGORIES_H

#import <objc/objc-runtime.h>

#define CATEGORY_PROPERTY( type ) \
static char name##Key; \
- (type*)get##type\
{\
return objc_getAssociatedObject(self, & name##Key);\
}\
- (void)set##type:(type*)value\
{\
objc_setAssociatedObject(self, & name##Key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}

#define CATEGORY_PROPERTY2( type, name ) \
static char name##Key; \
- (type)get##name\
{\
return objc_getAssociatedObject(self, & name##Key);\
}\
- (void)set##name:(type)value\
{\
objc_setAssociatedObject(self, & name##Key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}

#define CATEGORY_PROPERTY_BOOL( name ) \
static char name##Key; \
- (BOOL)get##name\
{ \
NSNumber *result = objc_getAssociatedObject(self, & name##Key);\
return (result) ? [result boolValue] : NO; \
}\
- (void)set##name:(BOOL)value\
{\
NSNumber *v = [NSNumber numberWithBool:value]; \
objc_setAssociatedObject(self, & name##Key, v, OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}

#endif
