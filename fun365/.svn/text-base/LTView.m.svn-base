

#import "LTView.h"

@implementation LTView

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
    // label
    self.descriptionLabel = [[UILabel alloc] init];
    _descriptionLabel.frame = CGRectMake(0, 0, self.frame.size.width / 3, 35);
    [self addSubview:_descriptionLabel];
    
    // textFeild
    self.inputTextFeild = [[UITextField alloc] init];
    _inputTextFeild.frame = CGRectMake(CGRectGetMaxX(_descriptionLabel.frame) , CGRectGetMinY(_descriptionLabel.frame), self.frame.size.width * 2 / 3, CGRectGetHeight(_descriptionLabel.frame));
    _inputTextFeild.borderStyle = UITextBorderStyleRoundedRect;
    
    [self addSubview:_inputTextFeild];
    
    
}
@end
