//
//  ViewController.m
//  EasyHUDDemo
//
//  Created by Sen on 2019/6/10.
//  Copyright © 2019年 easyhud. All rights reserved.
//

#import "ViewController.h"
#import "EasyHUD.h"

@interface ViewController ()
<UITableViewDelegate,UITableViewDataSource>
@end

@implementation ViewController
{
    NSArray* listInfo;
    NSArray* colors;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITableView* tbview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    tbview.delegate = self;
    tbview.dataSource = self;
    tbview.rowHeight = 100;
    [self.view addSubview:tbview];
    
    listInfo = @[@"我们每个人都在吸入灰尘",@"岂曰无衣，与子同袍",@"回家不积极，脑壳有问题",@"真尼玛像我年轻时候一样",@"我要是你我就拿根棍子从嘴里捅进去直到屁眼",@"看看是什么堵住了你满肚子的学问",@"于国于民都用的上，可就是倒不出来"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return listInfo.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    
    cell.textLabel.text = listInfo[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row % 2 == 0) {
        [EasyHUD showStatus:listInfo[indexPath.row]];
    }else {
        [EasyHUD showError:listInfo[indexPath.row]];
    }

}

@end
