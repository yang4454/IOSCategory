//
//  ViewController.m
//  IOSCategory
//
//  Created by Jeff on 2020/10/29.
//

#import "ViewController.h"
#import "OpenAndCloseViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
/** strong属性注释 */
@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic,strong) NSArray        *demoArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableview];
}

- (UITableView *)tableview {
    if(!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableview.delegate =self;
        _tableview.dataSource =self;
    }
    return _tableview;
}

#pragma mark - tableView dataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";//可复用单元格标识

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.text = self.demoArray[indexPath.row];
//        cell.textLabel.textColor = [UIColor greenColor];//设置当前单元格的显示字体的颜色
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.demoArray.count;
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self pushWithName:[self.demoArray objectAtIndex:indexPath.row]];
    
}

#pragma mark - private

- (void)pushWithName:(NSString *)selName {
    id subViewController = [[NSClassFromString(selName) alloc] init];
    [self.navigationController pushViewController:subViewController animated:YES];
}
- (NSArray *)demoArray{
    
    if (_demoArray == nil) {
        _demoArray = @[
            @"OpenAndCloseViewController",
            
            
        ];
    }
    return _demoArray;
}


@end
