//
//  Facebook+SDFFacebookTestUser.m
//  facebook-testuser
//
//  Created by Sam C de Freyssinet on 13/05/2012.
//  Copyright (c) 2012 Adapter Pattern. All rights reserved.
//

#import "Facebook+SDFFacebookTestUser.h"
#import "GTMHTTPFetcher.h"

@implementation Facebook (SDFFacebookTestUser)

- (void)authorizeTestUser:(NSArray *)permissions
           appAccessToken:(NSString *)appAccessToken;
{
    NSURLRequest *request = [self createGenerateUserTestRequest:appAccessToken
                                                          appId:_appId
                                                    permissions:permissions];
    
    GTMHTTPFetcher *httpFetcher = [self createHTTPFetcherWithRequest:request];
    
    [httpFetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        
        if (error)
        {
            NSString     *reason    = @"There was a problem creating a Facebook user";
            NSDictionary *eDict     = [NSDictionary dictionaryWithObject:error 
                                                                  forKey:@"error"];

            NSException  *exception = [NSException exceptionWithName:@"Facebook Error" 
                                                              reason:reason
                                                            userInfo:eDict];
            
            @throw exception;
        }
        
        NSDictionary *accessToken = [self createAccessTokenFromTestUserResponse:data];
        
        self.accessToken    = [accessToken objectForKey:@"accessToken"];
        self.expirationDate = [accessToken objectForKey:@"expires"];
        
        if (self.sessionDelegate)
        {            
            [self.sessionDelegate performSelector:@selector(fbDidLogin)];
        }
    }];
}

#pragma mark - Test User methods

- (NSURLRequest *)createGenerateUserTestRequest:(NSString *)appAccessToken 
                                          appId:(NSString *)appId
                                    permissions:(NSArray *)permissions
{
    NSMutableString *permissionsString = [[NSMutableString alloc] initWithCapacity:100];
    
    [permissions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx > 0)
        {
            [permissionsString appendFormat:@",%@", obj];
        }
        else 
        {
            [permissionsString appendString:obj];
        }
    }];
    
    NSString *url = [NSString stringWithFormat:@"https://graph.facebook.com/%@/accounts/test-users?installed=true&locale=en_US&permissions=%@&method=post&access_token=%@", appId, permissionsString, appAccessToken];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [permissionsString release];
    
    return request;
}

- (NSDictionary *)createAccessTokenFromTestUserResponse:(NSData *)response
{
    NSDictionary *jsonObject  = [NSJSONSerialization JSONObjectWithData:response 
                                                                options:-1 
                                                                  error:nil];
    
    NSDictionary *accessToken = [NSDictionary dictionaryWithObjectsAndKeys:
        [jsonObject objectForKey:@"access_token"], @"accessToken", 
        [NSDate dateWithTimeIntervalSinceNow:1000000000.0], @"expires", nil];
    
    return accessToken;
}

- (GTMHTTPFetcher *)createHTTPFetcherWithRequest:(NSURLRequest *)request
{
    GTMHTTPFetcher *httpFetcher = [GTMHTTPFetcher fetcherWithRequest:request];
    return [[httpFetcher retain] autorelease];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    abort();
}

@end
