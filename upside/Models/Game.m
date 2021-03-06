//
//  Game.m
//  StockPlay
//
//  Created by Victor Costan on 1/6/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "Game.h"

#import "AssetBook.h"
#import "AssetBook+RSS.h"
#import "AssetBook+StockCache.h"
#import "ControllerSupport.h"
#import "GameSyncController.h"
#import "ImobileSupport.h"
#import "NewsCenter.h"
#import "PendingOrdersSubmittingController.h"
#import "Portfolio.h"
#import "StockCache.h"
#import "TradeBook.h"


@implementation Game

#pragma mark Lifecycle

-(id)init {
  if ((self = [super init])) {
    assetBook = [[AssetBook alloc] init];
    tradeBook = [[TradeBook alloc] init];

    newsCenter = [[NewsCenter alloc] init];

    ZNTargetActionPair* syncSite =
        [[ZNTargetActionPair alloc] initWithTarget:self
                                            action:@selector(newGameData)];
    syncController = [[GameSyncController alloc] initWithGame:self];
    syncController.syncSite = syncSite;
    orderSubmittingController = [[PendingOrdersSubmittingController alloc]
                                 initWithTradeBook:tradeBook];
    orderSubmittingController.syncSite = syncSite;
    stockCache = [[StockCache alloc] init];
    stockCache.syncSite = syncSite;
    [syncSite release];

    newDataSite = [[ZNTargetActionSet alloc] init];
    
    [[ZNPushNotifications notificationSite]
     addTarget:self action:@selector(receivedPushNotification:)];                                                                
  }
  return self;
}

-(void)dealloc {
  [orderSubmittingController stopSyncing];
  [orderSubmittingController release];
  [syncController stopSyncing];
  [syncController release];
  [newsCenter release];
  [stockCache release];
  [assetBook release];
  [tradeBook release];
  [super dealloc];
}

# pragma mark Setup

-(void)setup {
  // TODO(overmind): push this down in a more specific file
  [newsCenter addTitle:@"Software Updates"
               withUrl:@"http://blog.istockplay.com/feeds/posts/default/-/updates?alt=rss"
            andRefresh:600.0];
  [newsCenter addTitle:@"New Features"
               withUrl:@"http://blog.istockplay.com/feeds/posts/default/-/features?alt=rss"
            andRefresh:600.0];
  [newsCenter addTitle:@"Zergling.Net Twitter"
               withUrl:@"http://twitter.com/statuses/user_timeline/20736529.rss"
            andRefresh:600.0];

  [assetBook loadRssFeedsIntoCenter:newsCenter];

  [assetBook loadTickersIntoStockCache:stockCache];
  [stockCache startSyncing];
  [syncController startSyncing];
  [orderSubmittingController startSyncing];
}

#pragma mark Accessors

@synthesize assetBook, tradeBook, stockCache, newsCenter;
@synthesize orderSubmittingController;
@synthesize newDataSite;

-(NSDate*)lastSyncTime {
  return syncController.lastSyncTime;
}

#pragma mark New Game Data Site

-(void)newGameData {
  [newDataSite perform];
}

-(void)syncData {
  [syncController syncOnce];
}

-(void)receivedPushNotification:(NSDictionary*)notification {
  // Automagically sync (refresh) when we receive notifications.
  [syncController syncOnce];
}

#pragma mark Singleton

static Game* sharedGame = nil;

+(Game*)sharedGame {
  @synchronized(self) {
    if (sharedGame == nil) {
      sharedGame = [[Game alloc] init];
      [sharedGame setup];
    }
  }
  return sharedGame;
}

@end
