//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "Business.h"
#import "BusinessCell.h"
#import "FilterTableViewController.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate>

@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSArray *businesses;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UISearchBar *searchbar;

-(void)fetchBusinessesWithQuery:(NSString *)query params:(NSDictionary *) params;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        [self fetchBusinessesWithQuery:@"Restaurants" params:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessCell" bundle:nil] forCellReuseIdentifier:@"BusinessCell"];
    
    self.tableView.estimatedRowHeight = 86;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(filterTap)];
    
    self.searchbar = [[UISearchBar alloc] init];
    [self.searchbar setPlaceholder:@"search"];
    self.navigationItem.titleView = self.searchbar;
    
}

- (void)filterTap{
    FilterTableViewController *filter = [[FilterTableViewController alloc] initWithNibName:@"FilterTableViewController" bundle:nil];
    
    filter.delegate = self;
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:filter];
    [self presentViewController:nvc animated:YES completion:nil];
    //[self showDetailViewController:filter sender:self];
    
}

- (void) filtersViewController:(FiltersViewController *)filtersViewController didChangeFilters:(NSDictionary *)filters{
    [self fetchBusinessesWithQuery:@"Restaurants" params:filters];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-( NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.businesses.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];
    cell.business = self.businesses[indexPath.row];
    return cell;
}

-(void)fetchBusinessesWithQuery:(NSString *)query params:(NSDictionary *)params{
    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    
    [self.client searchWithTerm:query params:params success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"response: %@", response);
        
        NSArray *businessDictionaries = response[@"businesses"];
        self.businesses = [Business businessesWithDictionaries:businessDictionaries];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

@end
