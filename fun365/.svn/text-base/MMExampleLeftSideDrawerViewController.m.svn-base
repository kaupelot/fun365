// Copyright (c) 2013 Mutual Mobile (http://mutualmobile.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "MMExampleLeftSideDrawerViewController.h"
#import "MMTableViewCell.h"
#import "logViewCell.h"
#import "ListViewController.h"

@interface MMExampleLeftSideDrawerViewController ()


@end

@implementation MMExampleLeftSideDrawerViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"Left will appear");
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"Left did appear");
    
    NSArray *news = @[@"46e618fd-2681-4a02-935f-8473a875fdce_1",@"3a4d6ba4-2e3f-4347-840b-32832abb7687_1",@"5693f641-b759-4488-b3c0-3fc3cca5c351_1",@"c64e7f97-c947-4732-8586-ecf8cb48cc51_1",@"95cdf20cb47b4cb2b7809520f60758ea_1",@"b78dc3ae8bf547eba0a02a475b19c590_1",@"0bd8eb284999412aba0580c623a7e564_1",@"5c5a71bf-cd3d-451c-87ba-319702d06bcf_1",@"9fafe05ad613469499df1319cba6f57b_1",@"382d78f7b9594b7f8560d155de4f7581_1",@"d88457660d7b407094d55b033a2c2063_1"];
    NSArray *essays = @[@"a06e2ebc-accd-4bc7-9311-613c7adf5a17_1",@"d1b01607-873f-400e-bd2f-332e5b9ce7f6_1",@"9f1cfa88-1d49-414d-b455-4f95173b1a56_1",@"4f5a53e3-753a-4634-8a09-39ab32d1eb8c_1",@"75c907cf2dfb48d2b10307f947034a3f_1",@"b8c788f69cf64ff5b9f05dfa711d95c7_1",@"8b28a90a108d482ba5e7adcd92829f00_1",@"0e7e9a77-c7e0-426c-a4a2-f731bdf9c6a8_1",@"e9d2582740e0450d9f6d950df85c51fb_1",@"e31932ce34ee4479848a924bd0113a87_1"];
    NSArray *jokes = @[@"3b3fd7e9-f2cb-4145-9387-eeb7affff9ac_1",@"09246944-fb72-4a25-8496-d5b5c441f103_1",@"c67e4e0e-299c-4c43-ab28-6d6c7b181bd3_1",@"3e279c07f300497fa98685ae3ad445a7_1",@"345ea9b9-fdb8-4bc7-8f2b-72680f4a827a_1",@"3367415c-7b9f-4874-ac4b-dc75390634f1_1",@"df7dfc75-8a8f-4410-bb18-fe6456f0fb49_1"];
    NSArray *pictures = @[@"16f9a42d-7385-4ea4-b3ac-05041fe40ffc_1",@"994f3724-da93-407d-84c2-46e6074648ed_1",@"dcbb16cfab3a49a78fb4e0c59730cee8_1",@"ba8408d6-78e7-4a94-93e6-45705030dc50_1",@"280311595f924cf8bd35a20cfaeb9851_1",@"4edbd81c2e04485b8aef0e316fbb5e59_1",@"6722b417186349be9ba10c28858768c1_1",@"52fd5e514761402380a7c7dc41717bb1_1",@"e1a93e513fc54900a865a6cb5731bcda_1",@"8aacbac7e3ff4471a9e2a6017e3400f9_1"];
    _cateArray = @[news,essays,jokes,pictures];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"Left will disappear");
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"Left did disappear");
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"dianji");
    ListViewController *listVC = [[ListViewController alloc] init];
    UINavigationController *listNC = [[UINavigationController alloc] initWithRootViewController:listVC];
    listVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    listVC.cateId = [self generateWithArray:_cateArray[indexPath.row - 1]];
    [self presentViewController:listNC animated:YES completion:nil];
}

- (NSString *)generateWithArray:(NSArray *)array
{
    NSInteger num = arc4random() % array.count;
    NSString *temp = array[num];
    return temp;
}

@end
