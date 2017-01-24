#import <Foundation/Foundation.h>

@interface PostCriteria : NSObject

@property (nonatomic, copy) NSArray* statuses;
@property (nonatomic, copy) NSString* language;
@property (nonatomic, copy) NSNumber* page;
@property (nonatomic, copy) NSNumber* size;


@end
