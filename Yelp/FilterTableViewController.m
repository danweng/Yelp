//
//  FilterTableViewController.m
//  Yelp
//
//  Created by Dan Weng on 6/25/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "FilterTableViewController.h"
#import "SwitchCell.h"

@interface FilterTableViewController ()<UITableViewDataSource,UITableViewDelegate,SwitchCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, readonly)NSDictionary *filters;
@property (nonatomic, strong) NSArray  *categories;
@property (nonatomic, strong)NSMutableSet *selectedCategories;

-(void)initCategories;

@end

@implementation FilterTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self){
        self.selectedCategories = [NSMutableSet set];
        [self initCategories];
    }
    
    return self;
}

-(NSDictionary *)filters{
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    
    if(self.selectedCategories.count > 0){
        NSMutableArray *name = [NSMutableArray array];
        for(NSDictionary *category in self.selectedCategories) {
            [name addObject:category[@"code"]];
        }
        NSString *categoryFilter = [name componentsJoinedByString:@","];
        [filters setObject:categoryFilter forKey:@"category_filter"];
    }
    
    return filters;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(onApplyButton)];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil] forCellReuseIdentifier:@"SwitchCell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (value){
        [self.selectedCategories addObject:self.categories[indexPath.row]];
    }else{
        [self.selectedCategories removeObject:self.categories[indexPath.row]];
    }
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
    cell.titleLabel.text = self.categories[indexPath.row][@"name"];
    cell.on = [self.selectedCategories containsObject:self.categories[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (void)onCancelButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onApplyButton{
    [self.delegate filtersViewController:self didChangeFilters:self.filters];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)initCategories{
    self.categories = @[@{@"name" : @"American, New", @"code": @"newamerican" },
                        @{@"name" : @"American, Traditional", @"code": @"tradamerican" },
                        @{@"name" : @"Asian Fusion", @"code": @"asianfusion" },
                        @{@"name" : @"Barbeque", @"code": @"bbq" },
                        @{@"name" : @"Beer Garden", @"code": @"beergarden" },
                        @{@"name" : @"Breakfast & Brunch", @"code": @"breakfast_brunch" }];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
