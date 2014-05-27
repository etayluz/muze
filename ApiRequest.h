//
//  ApiRequest.h
//  ScoutPeek
//
//  Created by Michael Jaffe on 11/28/13.
//
//

#import <Foundation/Foundation.h>
#import <AFHTTPRequestOperationManager.h>

typedef void (^ApiCompleteBlock) (NSDictionary *response, NSError *error);
@interface ApiRequest : NSObject {
    
}
@property (nonatomic, copy) ApiCompleteBlock block;
+(NSURLRequest *)request:(NSString *)url method:(NSString *)method params:(NSDictionary *)params completeBlock:(__strong ApiCompleteBlock)completeBlock ;

+(NSURLRequest *)multiPartRequest:(NSString *)url method:(NSString *)method params:(NSDictionary *)params completeBlock:(__strong ApiCompleteBlock)completeBlock ;

+(AFHTTPRequestOperationManager *)request;
+(NSString *)apiUrl:(NSString *)action;

@end
