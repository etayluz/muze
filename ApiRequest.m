//
//  ApiRequest.m
//  ScoutPeek
//
//  Created by Michael Jaffe on 11/28/13.
//
//

#import "ApiRequest.h"

@implementation ApiRequest {
    
}

+(AFHTTPRequestOperationManager *)request {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
 
    NSString *cookieStr = [NSString stringWithFormat:@"api_key=%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"ApiKey"]];
    NSUserDefaults *user_defaults = [NSUserDefaults standardUserDefaults];
    if ([user_defaults objectForKey:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"ApiAuthKeyName"]] != nil) {
        cookieStr = [NSString stringWithFormat:@"api_key=%@;authentication_token=%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"ApiKey"], [user_defaults objectForKey:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"ApiAuthKeyName"]]];
    }
    [manager.requestSerializer setValue:cookieStr forHTTPHeaderField:@"Cookie"];
    return manager;
}

+(NSString *)apiUrl:(NSString *)action {
    NSString *url = [NSString stringWithFormat:@"%@%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"ApiUrl"],action];
    NSLog(@"URL=%@", url);
    return url;
}

+(NSURLRequest *)request:(NSString *)url method:(NSString *)method params:(NSDictionary *)params completeBlock:(ApiCompleteBlock)completeBlock {
    url = [NSString stringWithFormat:@"%@%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"ApiUrl"],url];
    NSLog(@"URL=%@", url);
    NSMutableURLRequest *r = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    
    [r setHTTPShouldHandleCookies:YES];
	[r setHTTPMethod:method];
    [r setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [r setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    if (params != nil) {
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
        if ([method isEqualToString:@"GET"]) {
            [r setURL:[NSURL URLWithString:[ApiRequest addQueryStringToUrlString:url withDictionary:params]]];
        } else {
            [r setHTTPBody:jsonData];
        }
   
    }
    
    [r setAllHTTPHeaderFields:(NSDictionary *)[ApiRequest setCookieHeaders]];

    dispatch_queue_t apiQueue = dispatch_queue_create("Api Request Queue",NULL);
    dispatch_async(apiQueue, ^{
        
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *receivedData = [NSURLConnection sendSynchronousRequest:r returningResponse:&response error:&error];
        NSDictionary* json;
        if (!error) {
            json = [NSJSONSerialization JSONObjectWithData: receivedData options:kNilOptions error:&error];
            
            int statusCode = (int)[((NSHTTPURLResponse *)response) statusCode];
            if (statusCode != 200) {
                error = [[NSError alloc] initWithDomain:@"Api Error" code:0 userInfo:json];
                switch (statusCode) {
                    case 404:
                        error = [[NSError alloc] initWithDomain:@"Api Error" code:0 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:@"In-valid URL Request", nil],@"errors", nil]];
                        break;
                        
                    default:
                        break;
                }
            }
        } else {
            error =[[NSError alloc] initWithDomain:@"Api Error" code:0 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:@"Connection error. Could not connect to host.", nil],@"errors", nil]];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            completeBlock(json,error);
        });
    });
    return r;
    
}


+(NSURLRequest *)multiPartRequest:(NSString *)url method:(NSString *)method params:(NSDictionary *)params completeBlock:(ApiCompleteBlock)completeBlock {
  
    url = [NSString stringWithFormat:@"%@%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"ApiUrl"],url];
    NSMutableData *postData = [NSMutableData data];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
	[request setHTTPMethod:method];
    [request setAllHTTPHeaderFields:(NSDictionary *)[ApiRequest setCookieHeaders]];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary]   forHTTPHeaderField:@"Content-Type"];
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add the other POST params
    NSString *objectKey = [params allKeys][0];
    NSArray *keys = [params[objectKey] allKeys];
    params = params[objectKey];
    int l = (int)[keys count];
    for (int i=0; i<l; i++){
        NSLog(@"%@",[params objectForKey:[keys objectAtIndex:i]] );
        if (![[params objectForKey:[keys objectAtIndex:i]] isKindOfClass:[NSData class]]) {
            [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", [NSString stringWithFormat:@"%@[%@]",objectKey,[keys objectAtIndex:i]]] dataUsingEncoding:NSUTF8StringEncoding]];
            [postData appendData:[[params objectForKey:[keys objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
            [postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
 

    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *formData;
    
    for (int i=0; i<l; i++){
        if ([[params objectForKey:[keys objectAtIndex:i]] isKindOfClass:[NSData class]]) {
            [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", [NSString stringWithFormat:@"%@[%@]",objectKey,[keys objectAtIndex:i]]] dataUsingEncoding:NSUTF8StringEncoding]];
            [postData appendData:[formData dataUsingEncoding:NSUTF8StringEncoding]];
            [postData appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [postData appendData:[NSData dataWithData:[params objectForKey:[keys objectAtIndex:i]]]];
            [postData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postData];
    
    dispatch_queue_t apiQueue = dispatch_queue_create("Api Request Queue",NULL);
    dispatch_async(apiQueue, ^{
        
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSDictionary* json;
        if (!error) {
            json = [NSJSONSerialization JSONObjectWithData: receivedData options:kNilOptions error:&error];
            int statusCode = (int)[((NSHTTPURLResponse *)response) statusCode];
            if (statusCode != 200) {
                error = [[NSError alloc] initWithDomain:@"Api Error" code:0 userInfo:json];
                switch (statusCode) {
                    case 404:
                        error = [[NSError alloc] initWithDomain:@"Api Error" code:0 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:@"In-valid URL Request", nil],@"errors", nil]];
                        break;
                        
                    default:
                        break;
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completeBlock(json,error);
        });
    });
    return request;
}


+(NSDictionary *)setCookieHeaders {
    
    /*
     BE SURE TO SET THE ApiUrl,ApiKey and ApiAuthKeyName in the plist
    */
    NSArray* _cookies;
    NSHTTPCookie *cookie;
    NSString *domain = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ApiUrl"];
    NSString *api_key = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ApiKey"];
    NSMutableDictionary *properties = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                domain, NSHTTPCookieDomain,
                                @"\\", NSHTTPCookiePath,  // IMPORTANT!
                                @"api_key", NSHTTPCookieName,
                                api_key, NSHTTPCookieValue,
                                nil];
    

    cookie = [NSHTTPCookie cookieWithProperties:properties];
    // -- If user is logged in, send the auth_token too
    NSUserDefaults *user_defaults = [NSUserDefaults standardUserDefaults];
    if ([user_defaults objectForKey:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"ApiAuthKeyName"]] != nil) {
        NSDictionary *authDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  domain, NSHTTPCookieDomain,
                                  @"\\", NSHTTPCookiePath,  // IMPORTANT!
                                  @"authentication_token", NSHTTPCookieName,
                                  [user_defaults objectForKey:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"ApiAuthKeyName"]], NSHTTPCookieValue,
                                  nil];
        _cookies = [NSArray arrayWithObjects: cookie, [NSHTTPCookie cookieWithProperties:authDict], nil];
    } else {
        _cookies = [NSArray arrayWithObjects: cookie,nil];
    }
    
    
    return [NSHTTPCookie requestHeaderFieldsWithCookies:_cookies];
}

                       
                       
+(NSString*)urlEscapeString:(NSString *)unencodedString
            {
                CFStringRef originalStringRef = (__bridge_retained CFStringRef)unencodedString;
                NSString *s = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,originalStringRef, NULL, NULL,kCFStringEncodingUTF8);
                CFRelease(originalStringRef);
                return s;
            }
                       
                       
+(NSString*)addQueryStringToUrlString:(NSString *)urlString withDictionary:(NSDictionary *)dictionary
            {
                NSMutableString *urlWithQuerystring = [[NSMutableString alloc] initWithString:urlString];
                
                for (id key in dictionary) {
                    NSString *keyString = [key description];
                    NSString *valueString = [[dictionary objectForKey:key] description];
                    valueString = [valueString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    if ([urlWithQuerystring rangeOfString:@"?"].location == NSNotFound) {
                        [urlWithQuerystring appendFormat:@"?%@=%@", [self urlEscapeString:keyString], [self urlEscapeString:valueString]];
                    } else {
                        [urlWithQuerystring appendFormat:@"&%@=%@", [self urlEscapeString:keyString], [self urlEscapeString:valueString]];
                    }
                }
                return urlWithQuerystring;
            }
                       
@end
