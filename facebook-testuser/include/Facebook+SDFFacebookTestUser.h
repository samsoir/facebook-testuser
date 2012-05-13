//
//  Facebook+SDFFacebookTestUser.h
//  facebook-testuser
//
//  Created by Sam C de Freyssinet on 13/05/2012.
//  Copyright (c) 2012 Adapter Pattern. All rights reserved.
//

#import "Facebook.h"

@class GTMHTTPFetcher;

@interface Facebook (SDFFacebookTestUser)

#pragma mark - Authorize methods

/*!
    @method authorizeTestUser:appAccessToken:
    
    @abstract Creates and authenticates a Facebook Test User
    
    @discussion Creates and authorizes a Facebook Test User simulating the
    similar Facebook authroize: method. Unlike the regular facebook
    method, using this method will not follow the standard authentication
    flow via Safari, allowing automated testing tools such as Calabash
    to perform authentication with Facebook steps.
 
    @param array of permissions to request
    @param the application access token
 */
- (void)authorizeTestUser:(NSArray *)permissions
           appAccessToken:(NSString *)appAccessToken;

#pragma mark - Test User methods

/*!
    @method createGenerateUserTestRequest:appId:permissions
    
    @abstract Creates a request to generate a new test Facebook user
    with defined permissions.
 
    @discussion Creates an <tt>NSURLRequest</tt> object that will
    generate a new test Facebook user.
 
    @param the application access token
    @param the application id
    @param an array of permissions to authenticate with
 
    @return NSURLRequest
 */
- (NSURLRequest *)createGenerateUserTestRequest:(NSString *)appAccessToken 
                                          appId:(NSString *)appId
                                    permissions:(NSArray *)permissions;

/*!
    @method createAccessTokenFromTestUserResponse:
    
    @abstract decodes the json response and parses out the access token
 
    @param facebook response data object
 
    @return dictionary containing the access token and expiry
 */
- (NSDictionary *)createAccessTokenFromTestUserResponse:(NSData *)response;

/*!
    @method createHTTPFetcherWithRequest:
 
    @abstract creates a new Google Toolbox for Mac HTTP Fetcher object
 
    @param a request object to use with the HTTP Fetcher
 
    @return HTTP Fetcher object
 */
- (GTMHTTPFetcher *)createHTTPFetcherWithRequest:(NSURLRequest *)request;

@end
