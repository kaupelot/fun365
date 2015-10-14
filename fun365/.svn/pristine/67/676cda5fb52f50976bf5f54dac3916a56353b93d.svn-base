

#import "RegisterView.h"
#import "LTView.h"

@implementation RegisterView

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
    
    // 设置背景图片
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"13.png"]];
    imageView.frame = self.bounds;
    [self addSubview:imageView];
    
    // username
    self.userName = [[LTView alloc] initWithFrame:CGRectMake(self.frame.size.width / 8, 84, self.frame.size.width * 6 / 8, 50)];
    _userName.descriptionLabel.text = @"用户名:";
    _userName.descriptionLabel.textColor = [UIColor whiteColor];
    _userName.inputTextFeild.placeholder = @"6-15位数字或字母";
    [self addSubview:_userName];
    
    // password
    self.password = [[LTView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_userName.frame), CGRectGetMaxY(_userName.frame) + 10, CGRectGetWidth(_userName.frame), CGRectGetHeight(_userName.frame))];
    _password.descriptionLabel.text = @"密码:";
    _password.descriptionLabel.textColor = [UIColor whiteColor];
    _password.inputTextFeild.placeholder = @"6-15位数字或字母";
    [self addSubview:_password];
    
    // validatePassword
    self.validatePassword = [[LTView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_password.frame), CGRectGetMaxY(_password.frame) + 10, CGRectGetWidth(_password.frame), CGRectGetHeight(_password.frame))];
    _validatePassword.descriptionLabel.text = @"重复密码:";
    _validatePassword.descriptionLabel.textColor = [UIColor whiteColor];
    _validatePassword.inputTextFeild.placeholder = @"请再次输入密码";
    [self addSubview:_validatePassword];
    
    // emailAddress
    self.emailAddress = [[LTView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_validatePassword.frame), CGRectGetMaxY(_validatePassword.frame) + 10, CGRectGetWidth(_validatePassword.frame), CGRectGetHeight(_validatePassword.frame))];
    _emailAddress.descriptionLabel.text = @"邮箱:";
    _emailAddress.descriptionLabel.textColor = [UIColor whiteColor];
    _emailAddress.inputTextFeild.placeholder = @"请输入邮箱地址";
    [self addSubview:_emailAddress];
    
    // 注册按钮
    self.registerButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _registerButton.frame = CGRectMake(CGRectGetWidth(self.frame) * 3 / 10 , CGRectGetMaxY(_emailAddress.frame) + 30, CGRectGetWidth(self.frame) * 2 / 5,CGRectGetHeight(_emailAddress.frame) - 10);
    [_registerButton setTitle:@"注    册" forState:(UIControlStateNormal)];
    [_registerButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [_registerButton.layer setBorderWidth:1.5];
    _registerButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_registerButton.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [_registerButton.layer setCornerRadius:8.0];
    [self addSubview:_registerButton];
}


@end
