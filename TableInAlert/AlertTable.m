//
//  AlertTable.m
//  TableInAlert
//
//  Created by Line_Hu on 14-2-20.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

#import "AlertTable.h"
#define CONTAINER_WIDTH 260
#define CONTAINER_HEIGHT 390
#define INSIDE_CONTAINER_WIDTH 240
#define INSIDE_CONTAINER_HEIGHT 280
#define INSET_TOP_BOTTOM 60
#define INSET_LEFT_RIGHT 45
#define INSIDE_INSET_TOP_BOTTOM 45
#define INSIDE_LEFT_RIGHT 20
static const CGFloat LEFT_SIDE_INSET = 45.0;
static const CGFloat RIGHT_SIDE_INSET = -45.0;
@implementation AlertTable

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithParentView:(UIView *)parentView
{
    self = [super initWithFrame:parentView.frame];
    if(self)
    {
        self.currentOrientation = [UIDevice currentDevice].orientation;
        _parentView = parentView;
        self.frame = parentView.frame;
        NSLog(@"width:%f",self.frame.size.width);
        
    }
    return self;
}

- (void)modifyContainerAccordingToOrientation:(UIDeviceOrientation)ori
{
    
}

- (void)detectOrientation:(NSNotification *)no
{
    if(self.containerView)
    {
        NSLog(@"%d",[UIDevice currentDevice].orientation);
        _containerView.frame = UIEdgeInsetsInsetRect(self.frame, UIEdgeInsetsMake(60, 40, 60, 40));
        _insideContainerView.frame = UIEdgeInsetsInsetRect(_containerView.bounds, UIEdgeInsetsMake(40, 20, 40, 20));
        _mainTable.frame = CGRectMake(0, 0, _insideContainerView.frame.size.width, _insideContainerView.frame.size.height);
        _cancelButton.frame = CGRectMake(_insideContainerView.frame.origin.x, _insideContainerView.frame.size.height + 40, 65, 30);
        _confirmButton.frame = CGRectMake(_insideContainerView.frame.origin.x+65+_containerView.frame.size.width - 130-_insideContainerView.frame.origin.x*2, _insideContainerView.frame.size.height+40, 65, 30);
    }
}

- (void)showWithTitle:(NSString *)title;
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectOrientation:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    
    [self abandoned];
    _titleLabel.text = title;
    _containerView.layer.opacity = 0.5f;
    _containerView.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.0);
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    [self addSubview:_containerView];
    [_parentView addSubview:self];
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
                         _containerView.layer.opacity = 1.0f;
                         _containerView.backgroundColor = [UIColor whiteColor];
                         _containerView.layer.transform = CATransform3DMakeScale(1, 1, 1);
					 }
					 completion:NULL
     ];

}

- (void)dismiss
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _containerView.layer.transform = CATransform3DMakeScale(1, 1, 1);
    _containerView.layer.opacity = 1.0f;
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                         _containerView.layer.transform = CATransform3DMakeScale(0.5f, 0.6f, 1.0f);
                         _containerView.layer.opacity = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         for (UIView *v in [self subviews]) {
                             [v removeFromSuperview];
                         }
                         [self removeFromSuperview];
                     }
     ];
}


- (void)createContainerView
{
    self.containerView = [[UIView alloc] init];
    _containerView.layer.cornerRadius = 3.0f;
    _containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_containerView];
    NSLayoutConstraint *leftCon = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:45];
    NSLayoutConstraint *rightCon = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-45];
    NSLayoutConstraint *topCon = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:45];
    NSLayoutConstraint *bottomCon = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-45.0];
    [self addConstraint:rightCon];
    [self addConstraint:leftCon];
    [self addConstraint:topCon];
    [self addConstraint:bottomCon];
    
    self.insideContainerView = [[UIView alloc] init];
    _insideContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [_containerView addSubview:_insideContainerView];
    leftCon = [NSLayoutConstraint constraintWithItem:_insideContainerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:INSIDE_LEFT_RIGHT];
    rightCon = [NSLayoutConstraint constraintWithItem:_insideContainerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-INSIDE_LEFT_RIGHT];
    topCon = [NSLayoutConstraint constraintWithItem:_insideContainerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeTop multiplier:1.0 constant:INSIDE_INSET_TOP_BOTTOM];
    bottomCon = [NSLayoutConstraint constraintWithItem:_insideContainerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-INSIDE_INSET_TOP_BOTTOM];
    [_containerView addConstraint:leftCon];
    [_containerView addConstraint:rightCon];
    [_containerView addConstraint:topCon];
    [_containerView addConstraint:bottomCon];
    
    _insideContainerView.layer.cornerRadius = 3.0;
    _insideContainerView.layer.borderWidth = 1;
    _insideContainerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _mainTable = [[UITableView alloc] initWithFrame:_insideContainerView.frame style:UITableViewStylePlain];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    [_insideContainerView addSubview:_mainTable];
}

- (void)abandoned
{
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    if(deviceOrientation == UIDeviceOrientationLandscapeLeft | deviceOrientation == UIDeviceOrientationLandscapeRight)
    {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    else if(deviceOrientation == UIDeviceOrientationPortrait)
    {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    }
    else
    {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    
    CGRect screenRect = self.frame;
    self.frame = CGRectMake(0, 0, screenRect.size.width, screenRect.size.height);
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _containerView = [[UIView alloc] init];
    _containerView.frame = UIEdgeInsetsInsetRect(self.frame, UIEdgeInsetsMake(60, 40, 60, 40));
    _containerView.layer.cornerRadius = 5.0f;
//    _containerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _insideContainerView = [[UIView alloc] initWithFrame:UIEdgeInsetsInsetRect(_containerView.bounds, UIEdgeInsetsMake(40, 20, 40, 20))];
//    _insideContainerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _insideContainerView.layer.cornerRadius = 3.0f;
    _insideContainerView.layer.borderWidth = 1.0f;
    _insideContainerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((_containerView.frame.size.width - INSIDE_CONTAINER_WIDTH)/2,0, INSIDE_CONTAINER_WIDTH, 40)];
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin ;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:13];
    _titleLabel.numberOfLines = 0;
    _titleLabel.textColor = [UIColor blackColor];
    [_containerView addSubview:_titleLabel];
    [_containerView addSubview:_insideContainerView];
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _insideContainerView.frame.size.width, _insideContainerView.frame.size.height) style:UITableViewStylePlain];
    _mainTable.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    [_insideContainerView addSubview:_mainTable];
    _cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _cancelButton.frame = CGRectMake(_insideContainerView.frame.origin.x, _insideContainerView.frame.size.height + 40, 65, 30);
//    _cancelButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_containerView addSubview:_cancelButton];
    [_cancelButton addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    _confirmButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
//    _confirmButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_confirmButton addTarget:self action:@selector(clickConfirmButton) forControlEvents:UIControlEventTouchUpInside];
    _confirmButton.frame = CGRectMake(_insideContainerView.frame.origin.x+65+_containerView.frame.size.width - 130-_insideContainerView.frame.origin.x*2, _insideContainerView.frame.size.height+40, 65, 30);
    [_containerView addSubview:_confirmButton];

}

- (void)clickCancelButton
{
    [self.delegate cancelButtonClicked:self];
    [self dismiss];
}

- (void)clickConfirmButton
{
    [self.delegate confirmButtonClicked:self];
    [self dismiss];
}

- (void)setDataSources:(NSMutableArray *)dataSources
{
    _dataSources = dataSources;
    [_mainTable reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSources count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = [_dataSources objectAtIndex:indexPath.row];
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
