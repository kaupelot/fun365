

#import <UIKit/UIKit.h>
@class LTView;

@interface LoginView : UIView

@property (nonatomic,strong)LTView *userName;
@property (nonatomic,strong)LTView *password;

@property (nonatomic,strong)UIButton *loginButton;
@property (nonatomic,strong)UIButton *registerButton;

@end
