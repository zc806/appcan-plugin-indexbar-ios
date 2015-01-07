///
//  CMIndexBar.m
//
//  Created by Craig Merchant on 07/04/2011.
//

#import "CMIndexBar_IB.h"
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

@implementation CMIndexBar_IB

@synthesize delegate;
@synthesize highlightedBackgroundColor;
@synthesize textColor;

- (id)init {
    self = [super init];
	if (self) {
		// Default colors.
		self.textColor = [UIColor blackColor];
		self.highlightedBackgroundColor = [UIColor lightGrayColor];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        // Default colors.
        self.textColor = [UIColor blackColor];
		self.highlightedBackgroundColor = RGBACOLOR(146, 144, 155, 0.8);
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
    
	int i=0;
	int subcount=0;
	
	for (UIView *subview in self.subviews)
	{
		if ([subview isKindOfClass:[UILabel class]])
		{
			subcount++;
		}
	}
	
	for (UIView *subview in self.subviews)
	{
		if ([subview isKindOfClass:[UILabel class]])
		{
			float ypos;
			
			if(i == 0)
			{
				ypos = 0;
			}
			else if(i == subcount-1)
			{
				ypos = self.frame.size.height-24.0;
			}
			else
			{
				float sectionheight = ((self.frame.size.height-24.0)/subcount);
				
				sectionheight = sectionheight+(sectionheight/subcount);
				
				ypos = (sectionheight*i);
			}
			
			[subview setFrame:CGRectMake(0, ypos, self.frame.size.width, 24.0)];
			
			i++;
		}
	}
}

- (void) setIndexes:(NSArray*)indexes
{
	[self clearIndex];
	
	int i;
	
	for (i=0; i<[indexes count]; i++)
	{
		float ypos;
		
		if(i == 0)
		{
			ypos = 0;
		}
		else if(i == [indexes count]-1)
		{
			ypos = self.frame.size.height-24.0;
		}
		else
		{
			float sectionheight = ((self.frame.size.height-24.0)/[indexes count]);
			sectionheight = sectionheight+(sectionheight/[indexes count]);
			
			ypos = (sectionheight*i);
		}
		
		UILabel *alphaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ypos, self.frame.size.width, 24.0)];
		alphaLabel.textAlignment = UITextAlignmentCenter;
		alphaLabel.text = [indexes objectAtIndex:i];
        NSLog(@"liguofu---i==%d",i);
		alphaLabel.font = [UIFont fontWithName:@"Helvetica" size:13.0];
		alphaLabel.backgroundColor = [UIColor clearColor];
		alphaLabel.textColor = textColor;
		[self addSubview:alphaLabel];
		[alphaLabel release];
	}
}

- (void) clearIndex
{
	for (UIView *subview in self.subviews)
	{
		[subview removeFromSuperview];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesEnded");
	[super touchesEnded:touches withEvent:event];
    [delegate indexSelectionEndChange:self];
    [self touchesEndedOrCancelled:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesCancelled");
    [super touchesCancelled:touches withEvent:event];
    [delegate indexSelectionEndChange:self];
    [self touchesEndedOrCancelled:touches withEvent:event];
}

- (void) touchesEndedOrCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
 	UIView *backgroundView = (UIView*)[self viewWithTag:767];
	[backgroundView removeFromSuperview];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan");
	[super touchesBegan:touches withEvent:event];
	
	UIView *backgroundview = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.bounds.size.width, self.bounds.size.height)];
	[backgroundview setBackgroundColor:highlightedBackgroundColor];
	backgroundview.layer.cornerRadius = self.bounds.size.width/2;
	backgroundview.layer.masksToBounds = YES;
	backgroundview.tag = 767;
	[self addSubview:backgroundview];
	[self sendSubviewToBack:backgroundview];
	[backgroundview release];
	
    if (!self.delegate) return;
	
    CGPoint touchPoint = [[[event touchesForView:self] anyObject] locationInView:self];
    
	if(touchPoint.x < 0)
	{
		return;
	}
	
	NSString *title = nil;
	int count=0;
	
	for (UILabel *subview in self.subviews)
	{
		if ([subview isKindOfClass:[UILabel class]])
		{
			if(touchPoint.y < subview.frame.origin.y+subview.frame.size.height)
			{
				count++;
				title = subview.text;
				break;
			}
			
			count++;
			title = subview.text;
		}
	}
	[delegate indexSelectionDidChange:self index:count title:title];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesMoved");
    [super touchesMoved:touches withEvent:event];
    
	if (!self.delegate) return;
	
    CGPoint touchPoint = [[[event touchesForView:self] anyObject] locationInView:self];
	
	if(touchPoint.x < 0)
	{
		return;
	}
	
	NSString *title = nil;
	int count=0;
	
	for (UILabel *subview in self.subviews)
	{
		if ([subview isKindOfClass:[UILabel class]])
		{
			if(touchPoint.y < subview.frame.origin.y+subview.frame.size.height)
			{
				count++;
				title = subview.text;
				break;
			}
			
			count++;
			title = subview.text;
		}
	}
	
	[delegate indexSelectionDidChange:self index:count title:title];
}

@end
