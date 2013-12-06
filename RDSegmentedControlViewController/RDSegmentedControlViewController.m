//
//  RDSegmentedControlViewController.m
//  TestContainer
//
//  Created by Rémi Dayres on 30/03/13.
//  Copyright (c) 2013 Rémi Dayres. All rights reserved.
//

#import "RDSegmentedControlViewController.h"

#define kHeaderViewSize 40
#define kSegmentedControlTopBottomMargin 6
#define kSegmentedControlLeftRightMargin 10

@interface RDSegmentedControlViewController ()
@property (nonatomic, strong) UIView             *headerView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, weak) UIViewController   *selectedViewController;
@property (nonatomic, strong) UIView             *contentView;
@end

@implementation RDSegmentedControlViewController


- (id)init
{
    self = [super init];
    if (self) {
        self.headerColor = [UIColor colorWithWhite:0.17 alpha:1.];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.headerView addSubview:self.segmentedControl];
    [self.view       addSubview:self.headerView];
    [self.view       addSubview:self.contentView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.segmentedControl.selectedSegmentIndex = 0;
    [self segmentedControlChanged:self.segmentedControl];
}

- (void)segmentedControlChanged:(UISegmentedControl *)segmentedControl
{
    NSInteger index = segmentedControl.selectedSegmentIndex;
    self.selectedViewController = [self.viewControllers objectAtIndex:index];
}


#pragma mark - Properties

- (void)setSelectedViewController:(UIViewController *)selectedViewController
{
    if (_selectedViewController)
    {
        [_selectedViewController willMoveToParentViewController:nil];
        [_selectedViewController.view removeFromSuperview];
        [_selectedViewController removeFromParentViewController];
    }
    
    _selectedViewController = selectedViewController;
    
    [self addChildViewController:_selectedViewController];
    _selectedViewController.view.frame = self.contentView.bounds;
    [self.contentView addSubview:_selectedViewController.view];
    [_selectedViewController didMoveToParentViewController:self];
}

- (UIView *)headerView
{
    if(!_headerView)
    {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kHeaderViewSize)];
        _headerView.backgroundColor = self.headerColor;
    }
    return _headerView;
}

- (UIView *)contentView
{
    if (!_contentView)
    {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                kHeaderViewSize,
                                                                self.view.frame.size.width,
                                                                self.view.frame.size.height - kHeaderViewSize)];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    }
    return _contentView;
}

- (UISegmentedControl *)segmentedControl
{
    if (!_segmentedControl)
    {
        _segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(kSegmentedControlLeftRightMargin,
                                                                                 kSegmentedControlTopBottomMargin,
                                                                                 self.view.frame.size.width - 2*kSegmentedControlLeftRightMargin,
                                                                                 kHeaderViewSize - 2*kSegmentedControlTopBottomMargin)];
        _segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        [_segmentedControl addTarget:self
                                  action:@selector(segmentedControlChanged:)
                        forControlEvents:UIControlEventValueChanged];
        int index = 0;
        for (UIViewController *vc in self.viewControllers) {
            [_segmentedControl insertSegmentWithTitle:vc.title atIndex:index animated:NO];
            index ++;
        }
    }
    return _segmentedControl;
}


@end
