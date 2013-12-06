//
//  RDSegmentedControlViewController.m
//  TestContainer
//
//  Created by Rémi Dayres on 30/03/13.
//  Copyright (c) 2013 Rémi Dayres. All rights reserved.
//

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Imports

#import "RDSegmentedControlViewController.h"

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Types

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Defines & Constants

static CGFloat const kSegmentedControlTopBottomMargin = 6;
static CGFloat const kSegmentedControlLeftRightMargin = 10;
static CGFloat const kHeaderViewHeight = 40;

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Macros

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private Interface

@interface RDSegmentedControlViewController ()

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Outlets

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private Properties

@property (nonatomic, weak)   UIViewController   *selectedViewController;
@property (nonatomic, strong) UIView             *headerView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIView             *contentView;

@end

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Implementation

@implementation RDSegmentedControlViewController

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Setup & Teardown

-(void)commonRDSegmentedControlViewController
{
    self.headerColor = [UIColor colorWithWhite:0.17 alpha:1.];
}

-(id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self commonRDSegmentedControlViewController];
    }
    return self;
}

-(id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self commonRDSegmentedControlViewController];
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Superclass Overrides

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setup segmentedControl
    CGRect segmentedFrame = CGRectMake(
                                       kSegmentedControlLeftRightMargin,
                                       kSegmentedControlTopBottomMargin,
                                       self.view.frame.size.width - 2*kSegmentedControlLeftRightMargin,
                                       kHeaderViewHeight - 2*kSegmentedControlTopBottomMargin
                                       );
    self.segmentedControl = [[UISegmentedControl alloc] initWithFrame:segmentedFrame];
    self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [self.segmentedControl addTarget:self
                              action:@selector(segmentedControlChanged:)
                    forControlEvents:UIControlEventValueChanged];
    int index = 0;
    for (UIViewController *vc in self.viewControllers) {
        [self.segmentedControl insertSegmentWithTitle:vc.title atIndex:index animated:NO];
        index ++;
    }
    
    // setup headerView
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kHeaderViewHeight)];
    self.headerView.backgroundColor = self.headerColor;
    [self.headerView addSubview:self.segmentedControl];
    
    // setup contentView
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                kHeaderViewHeight,
                                                                self.view.frame.size.width,
                                                                self.view.frame.size.height - kHeaderViewHeight)];
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    
    [self.view       addSubview:self.headerView];
    [self.view       addSubview:self.contentView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.segmentedControl.selectedSegmentIndex = 0;
    [self segmentedControlChanged:self.segmentedControl];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public methods

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

///////////////////////////////////////////////////////////////////////////////
#pragma mark - Private methods

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Actions

- (void)segmentedControlChanged:(UISegmentedControl *)segmentedControl
{
    NSInteger index = segmentedControl.selectedSegmentIndex;
    self.selectedViewController = [self.viewControllers objectAtIndex:index];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - XXXDataSource / XXXDelegate methods



@end
