
#import "LoginView.h"
#import "LTView.h"
@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_setUpView];
    }
    return self;
}

- (void)p_setUpView
{
    self.backgroundColor = [UIColor redColor];
    
    // 设置背景图片
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"13.png"]];
    imageView.frame = self.bounds;
    [self addSubview:imageView];
    
    
    
    // userName
    self.userName = [[LTView alloc] initWithFrame:CGRectMake(self.frame.size.width / 8, 114, self.frame.size.width * 6 / 8, 50)];
    _userName.descriptionLabel.text = @"用户名:";
    _userName.descriptionLabel.textColor = [UIColor whiteColor];
    _userName.inputTextFeild.placeholder = @"请输入用户名";
    [self addSubview:_userName];
    
    
    // password
    self.password = [[LTView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_userName.frame), CGRectGetMaxY(_userName.frame) + 10, CGRectGetWidth(_userName.frame), CGRectGetHeight(_userName.frame))];
    _password.descriptionLabel.text = @"密   码:";
    _password.descriptionLabel.textColor = [UIColor whiteColor];
    _password.inputTextFeild.placeholder = @"请输入密码";
    _password.inputTextFeild.secureTextEntry = YES;
    [self addSubview:_password];
    
    // register
    self.registerButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _registerButton.frame = CGRectMake(CGRectGetWidth(self.frame) / 6, CGRectGetMaxY(_password.frame) + 30, CGRectGetWidth(self.frame) / 4, CGRectGetHeight(_password.frame) - 10);
    [_registerButton setTitle:@"注  册" forState:(UIControlStateNormal)];
    [_registerButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [_registerButton.layer setBorderWidth:1.5];
    _registerButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_registerButton.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [_registerButton.layer setCornerRadius:8.0];
    [self addSubview:_registerButton];
    
    // loginButton
    self.loginButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _loginButton.frame = CGRectMake(CGRectGetWidth(self.frame) * 7 / 12, CGRectGetMaxY(_password.frame) + 30, CGRectGetWidth(self.frame) / 4, CGRectGetHeight(_password.frame) - 10);
    [_loginButton setTitle:@"登  录" forState:(UIControlStateNormal)];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [_loginButton.layer setBorderWidth:1.5];
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_loginButton.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [_loginButton.layer setCornerRadius:8.0];
    [self addSubview:_loginButton];
}

@end
