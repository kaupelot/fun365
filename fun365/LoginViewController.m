

#import "LoginViewController.h"
#import "LoginView.h"
#import "RegisterViewController.h"
#import "LTView.h"
#import "DataBaseHandle.h"


@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic,strong)LoginView *loginView;

@end

@implementation LoginViewController

- (void)loadView
{
    self.loginView = [[LoginView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.view = _loginView;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *string = [ud valueForKey:@"login"];
    if ([string isEqualToString:@"yes"]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    [self nightMode];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"用户登录";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(leftBarButtonAction:)];
    
    // 登录按钮
    [self.loginView.loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    // 注册按钮
    [self.loginView.registerButton addTarget:self action:@selector(registerButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    // 设置代理
    _loginView.userName.inputTextFeild.delegate = self;
    _loginView.password.inputTextFeild.delegate = self;
}

#pragma makr -------------- UINavigationBar 左侧的按钮响应事件 ---------------

- (void)leftBarButtonAction:(UIBarButtonItem *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark  ------- 登录,注册 按钮响应事件 --------------

- (void)loginButtonAction:(UIButton *)sender
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *string = [NSString string];
    NSString *inputName = _loginView.userName.inputTextFeild.text;
    
    NSString *cql = [NSString stringWithFormat:@"select * from %@ where userName = '%@'",@"UserInfo",inputName];
    AVCloudQueryResult *result = [AVQuery doCloudQueryWithCQL:cql];
    NSArray *temp = result.results;
    if (temp.count != 0) {
    AVObject *temp1 = result.results[0];
    NSString *temp2 = [temp1 objectForKey:@"password"];
    NSString *count = [temp1 objectForKey:@"loginCount"];
    NSInteger countNow = [count integerValue];
    countNow += 1;
    NSString *countNew = [NSString stringWithFormat:@"%ld",(long)countNow];
    
   if (![_loginView.password.inputTextFeild.text isEqualToString:temp2]) {
        string = @"密码错误";

    } else {

        [ud setObject:@"yes" forKey:@"login"];
        [ud setObject:inputName forKey:@"user"];
        [ud setObject:countNew forKey:@"loginCount"];
        
        string = @"登录成功";
        [temp1 setObject:countNew forKey:@"loginCount"];
        AVFile *file = [temp1 objectForKey:@"image"];
        NSData *imageData = [file getData];
        [temp1 save];
        [ud setObject:imageData forKey:@"image"];
        [ud synchronize];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    } else {
        string = @"此账号不存在";
    }
    if (![string isEqualToString:@"登录成功"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:string delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
    
}


- (void)registerButtonAction:(UIButton *)sender
{
    
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    
    [self.navigationController pushViewController:registerVC animated:YES];
}

#pragma mark 夜间模式
- (void)nightMode
{
    // 夜间模式初始化
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *mode = [ud objectForKey:@"night"];
    if ([mode isEqualToString:@"yes"]) {
        self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    }else{
        self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    }
}

// 收键盘
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![_loginView.userName.inputTextFeild isExclusiveTouch]) {
        [_loginView.userName.inputTextFeild resignFirstResponder];
    }
    if (![_loginView.password.inputTextFeild isExclusiveTouch]) {
        [_loginView.password.inputTextFeild resignFirstResponder];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// 防止键盘遮挡视图
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UIView *superView = [textField superview];
    CGFloat offset = _loginView.frame.size.height - (superView.frame.origin.y + superView.frame.size.height + 216 + 50);
    
    if (offset <= 0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect r = _loginView.frame;
            r.origin.y = offset;
            _loginView.frame = r;
        }];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect r = _loginView.frame;
        r.origin.y = 0;
        _loginView.frame = r;
    }];
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
