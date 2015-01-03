//
//  MKInfoPanel.m
//  HorizontalMenu
//
//  Created by Mugunth on 25/04/11.
//  Copyright 2011 Steinlogic. All rights reserved.
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above
//  Read my blog post at http://mk.sg/8e on how to use this code

//  As a side note on using this code, you might consider giving some credit to me by
//	1) linking my website from your app's website 
//	2) or crediting me inside the app's credits page 
//	3) or a tweet mentioning @mugunthkumar
//	4) A paypal donation to mugunth.kumar@gmail.com
//
//  A note on redistribution
//	While I'm ok with modifications to this source code, 
//	if you are re-publishing after editing, please retain the above copyright notices

#import "MKEntryPanel.h"
#import <QuartzCore/QuartzCore.h>

// Private Methods
// this should be added before implementation block 

@interface MKEntryPanel (PrivateMethods)
+(MKEntryPanel*) panelWithFrame: (CGRect)frame;
@end


@implementation DimView

- (id)initWithParent:(UIView*) aParentView onTappedSelector:(SEL) tappedSel
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        // Initialization code
        parentView = aParentView;
        onTapped = tappedSel;
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.0;
    }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [parentView performSelector:onTapped];
}
- (void)dealloc
{
    [super dealloc];
}
@end

@implementation MKEntryPanel
@synthesize closeBlock = _closeBlock;
@synthesize titleLabel = _titleLabel;
@synthesize entryField = _entryField;
@synthesize backgroundGradient = _backgroundGradient;
@synthesize dimView = _dimView;
@synthesize isShow = _isShow;
@synthesize dismissBlock = _dismissBlock;


#define KINset_MAX_X 20
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        /*!
         *  @author Dylan
         */
        
        //TODO: 这里可以修改他们的样式 背景颜色 以及属性。。。
        
        // imageView
        self.backgroundGradient = [[UIImageView alloc] initWithFrame:self.frame];
        _backgroundGradient.image = [UIImage imageNamed:@"TopBar"];
        _backgroundGradient.userInteractionEnabled = YES;
        [self addSubview:_backgroundGradient];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(_backgroundGradient.frame), 30)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:14.];
        [self addSubview:_titleLabel];
        
        self.entryField = [[UITextField alloc] initWithFrame:CGRectMake(KINset_MAX_X, CGRectGetMaxY(_titleLabel.frame), CGRectGetWidth(_backgroundGradient.frame) - 2 * KINset_MAX_X, 30)];
        _entryField.borderStyle = UITextBorderStyleRoundedRect;
        _entryField.placeholder = @"输入关键字检索";
        _entryField.delegate = self;
        _entryField.returnKeyType = UIReturnKeySearch;
        [self addSubview:_entryField];
        
    }
    return self;
}

+(MKEntryPanel*) panelWithFrame: (CGRect)frame
{
    MKEntryPanel *panel =  [[MKEntryPanel alloc] initWithFrame:frame];
    
    panel.backgroundGradient.image = [[UIImage imageNamed:@"TopBar"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];

    CATransition *transition = [CATransition animation];
	transition.duration = kAnimationDuration;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionPush;	
	transition.subtype = kCATransitionFromBottom;
	[panel.layer addAnimation:transition forKey:nil];
    
    return panel;
}

+(void) showPanelWithTitle:(NSString*) title inView:(UIView*) view onTextEntered:(CloseBlock) editingEndedBlock frame: (CGRect)frame dismissBlock: (DismissBlock)dismiss
{
    
    MKEntryPanel *panel = [MKEntryPanel panelWithFrame:frame];
    panel.closeBlock = editingEndedBlock;
    panel.dismissBlock = dismiss;
    panel.titleLabel.text = title;
    [panel.entryField becomeFirstResponder];
    
    panel.dimView = [[[DimView alloc] initWithParent:panel onTappedSelector:@selector(cancelTapped:)] autorelease];
    CATransition *transition = [CATransition animation];
	transition.duration = kAnimationDuration;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionFade;
	[panel.dimView.layer addAnimation:transition forKey:nil];
    panel.dimView.alpha = 0.8;
    [view addSubview:panel.dimView];
    [view addSubview:panel];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self performSelectorOnMainThread:@selector(hidePanel) withObject:nil waitUntilDone:YES];
    self.closeBlock(self.entryField.text);
    return YES;
}

-(void) cancelTapped:(id) sender
{
    [self performSelectorOnMainThread:@selector(hidePanel) withObject:nil waitUntilDone:YES];    
}

-(void) hidePanel
{
    [self.entryField resignFirstResponder];
    CATransition *transition = [CATransition animation];
	transition.duration = kAnimationDuration;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionPush;	
	transition.subtype = kCATransitionFromTop;
	[self.layer addAnimation:transition forKey:nil];
    self.frame = CGRectMake(0, -self.frame.size.height, 320, self.frame.size.height); 
    
    transition = [CATransition animation];
	transition.duration = kAnimationDuration;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionFade;
	self.dimView.alpha = 0.0;
	[self.dimView.layer addAnimation:transition forKey:nil];
    
    self.dismissBlock();
    [self.dimView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.40];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.45];
}

- (void)dealloc
{
    [super dealloc];
}

@end


