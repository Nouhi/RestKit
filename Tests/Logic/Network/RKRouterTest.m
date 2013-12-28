//
//  RKRouterTest.m
//  RestKit
//
//  Created by Blake Watters on 12/7/12.
//  Copyright (c) 2012 RestKit. All rights reserved.
//

#import "RKTestEnvironment.h"
#import "RKRouter.h"
#import "RKTestUser.h"

@interface RKRouterTest : RKTestCase
@end

@implementation RKRouterTest

- (void)testChangingBaseURL
{
    NSURL *originalURL = [NSURL URLWithString:@"http://restkit.org/"];
    NSURL *newURL = [NSURL URLWithString:@"http://google.com/"];
    RKRouter *router = [[RKRouter alloc] initWithBaseURL:originalURL];
    router.baseURL = newURL;
    expect(router.baseURL).to.equal(newURL);
}

- (void)testResourcePathForObject
{
    RKRouter *router = [[RKRouter alloc] initWithBaseURL:[NSURL URLWithString:@"http://restkit.org/"]];
    [router.routeSet addRoute:[RKRoute routeWithClass:[RKTestUser class] URITemplateString:@"/users/{userID}" method:RKHTTPMethodAny]];
    RKTestUser *user = [RKTestUser new];
    user.userID = [NSNumber numberWithInteger:12345];
    NSURL *URL = [router URLForObject:user method:RKHTTPMethodGET];
    assertThat(URL.path, is(equalTo(@"/users/12345")));
}

- (void)testResourcePathForRouteNamed
{
    RKRouter *router = [[RKRouter alloc] initWithBaseURL:[NSURL URLWithString:@"http://restkit.org/"]];
    [router.routeSet addRoute:[RKRoute routeWithName:@"airlines_list" URITemplateString:@"/airlines.json" method:RKHTTPMethodGET]];
    NSURL *URL = [router URLForRouteNamed:@"airlines_list" method:nil object:nil];
    assertThat(URL.path, is(equalTo(@"/airlines.json")));
}

- (void)testResourcePathForRouteNamedInterpolatedWithObject
{
    RKRouter *router = [[RKRouter alloc] initWithBaseURL:[NSURL URLWithString:@"http://restkit.org/"]];
    [router.routeSet addRoute:[RKRoute routeWithName:@"user_bookmarks" URITemplateString:@"/users/{userID}/bookmarks" method:RKHTTPMethodGET]];
    RKTestUser *user = [RKTestUser new];
    user.userID = [NSNumber numberWithInteger:12345];
    NSURL *URL = [router URLForRouteNamed:@"user_bookmarks" method:nil object:user];
    assertThat(URL.path, is(equalTo(@"/users/12345/bookmarks")));
}

@end
