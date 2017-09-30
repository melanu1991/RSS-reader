#import "VAKSettingsViewController.h"
#import "VAKSlideMenuViewController.h"
#import "VAKSlideMenuDelegate.h"
#import "VAKUIView+AnimationViews.h"

@interface VAKSettingsViewController () <VAKSlideMenuDelegate>

@property (weak, nonatomic) IBOutlet UIView *settingsView;

@end

@implementation VAKSettingsViewController

#pragma mark - UIBarButtonItem actions

- (IBAction)slideMenuButtonPressed:(UIBarButtonItem *)sender {
    [[VAKSlideMenuViewController sharedSlideMenu] showMenu];
    [VAKSlideMenuViewController sharedSlideMenu].delegate = self;
    [UIView animateWithDuration:0.25f coordinateX:[UIScreen mainScreen].bounds.size.width / 2.f views:@[self.navigationController.navigationBar, self.settingsView]];
}

#pragma mark - VAKSlideMenuDelegate

- (void)animateHideSlideMenu {
    [UIView animateWithDuration:0.25f coordinateX:0.f views:@[self.navigationController.navigationBar, self.settingsView]];
}

@end
