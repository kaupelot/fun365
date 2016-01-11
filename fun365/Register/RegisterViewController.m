

#import "RegisterViewController.h"
#import "RegisterView.h"
#import "LTView.h"
#import "DataBaseHandle.h"

@interface RegisterViewController ()<UITextFieldDelegate>

@property (nonatomic,strong)RegisterView *registerView;
@property (nonatomic,strong)UIButton *registerButton;
@end

@implementation RegisterViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self nightMode];
}

- (void)loadView
{
    
    self.registerView = [[RegisterView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.view = _registerView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStylePlain) target:self action:@selector(backAction:)];
    
    [_registerView.registerButton addTarget:self action:@selector(rightAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.navigationItem.title = @"用户注册";
    
    // 设置代理
    _registerView.userName.inputTextFeild.delegate = self;
    _registerView.password.inputTextFeild.delegate = self;
    _registerView.validatePassword.inputTextFeild.delegate = self;
    _registerView.emailAddress.inputTextFeild.delegate = self;
}


#pragma mark ------------ 注册 响应事件  -------------------

- (void)backAction:(UIBarButtonItem *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)rightAction:(UIBarButtonItem *)sender
{
    NSString *string = [NSString string];
    NSString *userName = _registerView.userName.inputTextFeild.text;
    NSString *password1 = _registerView.password.inputTextFeild.text;
    NSString *password2 = _registerView.validatePassword.inputTextFeild.text;
    NSString *email = _registerView.emailAddress.inputTextFeild.text;
    
    AVObject *regist = [AVObject objectWithClassName:@"UserInfo"];
    NSString *cql = [NSString stringWithFormat:@"select password from %@ where userName = '%@'",@"UserInfo",userName];
    AVCloudQueryResult *result = [AVQuery doCloudQueryWithCQL:cql];
    NSArray *temp = result.results;
    
    if (temp.count != 0) {
        string = @"此用户名已经存在";
        
    } else if (![self isPassword:userName] || ![self isPassword:password1] ) {
        
        string = @"请输入正确格式的用户名或密码";
    } else if (![password1 isEqualToString:password2]) {
        string = @"密码输入不一致";
    } else if ([email isEqualToString:@""] || ![self isEmailAddress:email] ){
        
        string = @"请输入正确的邮箱地址";
    
    } else {
        
        // 写入用户信息
        NSString *userName = _registerView.userName.inputTextFeild.text;
    
        NSString *passWord = _registerView.password.inputTextFeild.text;
        NSString *emailAddress = _registerView.emailAddress.inputTextFeild.text;
        NSString *count = @"0";
        
        [regist setObject:userName forKey:@"userName"];
        [regist setObject:passWord forKey:@"password"];
        [regist setObject:emailAddress forKey:@"email"];
        [regist setObject:count forKey:@"loginCount"];
        [regist save];
        
        string = @"注册成功";
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:@"yes" forKey:@"login"];
        [ud setObject:userName forKey:@"user"];
        [ud setObject:count forKey:@"loginCount"];
        [ud synchronize];
        // pop
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:string delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

- (BOOL)isPassword:(NSString *)str
{
    NSString *      regex = @"(^[A-Za-z0-9]{6,16}$)";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:str];
}

- (BOOL)isEmailAddress:(NSString*)candidate
{
    NSString* emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

// 收键盘
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![_registerView.userName.inputTextFeild isExclusiveTouch]) {
        [_registerView.userName.inputTextFeild resignFirstResponder];
    }
    if (![_registerView.password.inputTextFeild isExclusiveTouch]) {
        [_registerView.password.inputTextFeild resignFirstResponder];
    }
    if (![_registerView.validatePassword.inputTextFeild isExclusiveTouch]) {
        [_registerView.validatePassword.inputTextFeild resignFirstResponder];
    }
    if (![_registerView.emailAddress.inputTextFeild isExclusiveTouch]) {
        [_registerView.emailAddress.inputTextFeild resignFirstResponder];
    }
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



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// 防止键盘遮挡视图
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UIView *superView = [textField superview];
    CGFloat offset = _registerView.frame.size.height - (superView.frame.origin.y + superView.frame.size.height + 216 + 80);
    NSLog(@"%f",offset);
    if (offset <= 20) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect r = _registerView.frame;
            r.origin.y = offset;
            _registerView.frame = r;
        }];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect r = _registerView.frame;
        r.origin.y = 0;
        _registerView.frame = r;
    }];
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
