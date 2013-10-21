
#import "IDSModalAnimatedTransitioningController.h"

@implementation IDSModalAnimatedTransitioningController

- (NSTimeInterval)transitionDuration:(id)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id)transitionContext {
    // Obtain state from the Context:
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    // Obtain the container view:
    UIView *containerView = [transitionContext containerView];

    // Set the initial state:
    CGRect screenBounds = [[UIScreen mainScreen] bounds];

    CGAffineTransform completionTranslationTransform;
    UIViewController *animatingViewController;

    // Are we being asked to reverse the animation (i.e. dismissal)?
    if (self.reverse) {
        // YES: We're going to dismiss:
        animatingViewController = fromViewController;
        completionTranslationTransform = CGAffineTransformMakeTranslation(0, screenBounds.size.height);
    }
    else {
        // NO: We're going to present:
        animatingViewController = toViewController;
        CGAffineTransform startingTranslationTransform =
			CGAffineTransformMakeTranslation(0, screenBounds.size.height);
        completionTranslationTransform = CGAffineTransformIdentity;

        // Set the toViewController to its initial position, since it wouldn't be on screen as yet:
        toViewController.view.transform = startingTranslationTransform;

        // Add the view of the incoming view controller:
        [containerView addSubview:toViewController.view];
    }

    // Animate
    NSTimeInterval duration = [self transitionDuration:transitionContext];

     [UIView animateWithDuration:duration
                           delay:0.0
          usingSpringWithDamping:0.75
           initialSpringVelocity:0.35
      options:UIViewAnimationOptionCurveLinear
                      animations:^{
         animatingViewController.view.transform = completionTranslationTransform;
     }
     completion:^(BOOL finished) {
         if (self.reverse) { [fromViewController.view removeFromSuperview]; }
         // Inform the context of completion:
         [transitionContext completeTransition:YES];
     }];
}

@end
