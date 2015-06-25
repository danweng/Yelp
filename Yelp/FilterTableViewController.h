//
//  FilterTableViewController.h
//  Yelp
//
//  Created by Dan Weng on 6/25/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FiltersViewController;

@protocol FiltersViewControllerDelegate <NSObject>

-(void)filtersViewController:(FiltersViewController *) filtersViewController didChangeFilters:(NSDictionary *)filters;
@end

@interface FilterTableViewController : UITableViewController

@property (nonatomic, weak) id<FiltersViewControllerDelegate> delegate;


@end
