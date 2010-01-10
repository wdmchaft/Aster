//
//  SRNamePlate.m
//  Sterren
//
//  Created by Jan-Willem Buurlage on 01-12-09.
//  Copyright 2009 Web6.nl Diensten. All rights reserved.
//

#import "SRNamePlate.h"


@implementation SRNamePlate

@synthesize yTranslate, visible, hiding, info, elements, selectedType;

-(id)init {
	if(self = [super self]) {
		selectedType = 0;
		
		elements = [[NSMutableArray alloc] init];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(112, 288, 256, 32)
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"nameplatebg.png"]] 
															identifier:@"nameplate" 
															 clickable:NO]];
		
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(335, 281, 25, 50)
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"info.png"]] 
															identifier:@"info" 
															 clickable:YES]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(150,281, 128,32) 
															   texture:nil
															identifier:@"text" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(205,279, 128,32) 
															   texture:nil
															identifier:@"text-transparent" 
															 clickable:NO]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(117, 289, 32, 32)
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"close.png"]] 
															identifier:@"close_nameplate" 
															 clickable:YES]];
		
		[elements addObject:[[SRInterfaceElement alloc] initWithBounds:CGRectMake(313, 293, 25, 25)
															   texture:[[Texture2D alloc] initWithImage:[UIImage imageNamed:@"add_list.png"]] 
															identifier:@"add_list" 
															 clickable:YES]];
		
		yTranslate = 32;
		visible = NO;
		info = NO;
	}
	return self;	
}

-(void)draw {
	
	
	glTranslatef(0, yTranslate, 0);
	for (SRInterfaceElement* mElement in elements) {
		if([mElement identifier] == @"text-transparent") {
			glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
			glColor4f(0.294f, 0.513f, 0.93f, 1.0f);
			[[mElement texture] drawInRect:[mElement bounds]];
			glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
		}
		else if([mElement identifier] == @"text") {
			glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
			glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
			[[mElement texture] drawInRect:[mElement bounds]];
			glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
		}
		else if([mElement identifier] == @"info") {
			if(info) {
				CGRect myRect = [mElement bounds];
				myRect.size.height = 25;
				myRect.origin.y = myRect.origin.y + 12;
			glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
			[[mElement texture] drawInRect:myRect];
			}
		}
		else {
			glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
			[[mElement texture] drawInRect:[mElement bounds]];
		}
	}
	glTranslatef(0, -yTranslate, 0);

	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}

-(void)show {
	visible = YES;
	hiding = FALSE;
}

-(void)hide {
	hiding = TRUE;
}

-(void)setName:(NSString*)name inConstellation:(NSString*)constellation showInfo:(BOOL)theInfo {	
	if(name == nil || [name isEqualToString:@""] || [name isEqualToString:@" "]) {
		name = NSLocalizedString(@"Nameless",@"");
	}
	
	[[[elements objectAtIndex:2] texture] release];
	[[[elements objectAtIndex:3] texture] release];
	[[elements objectAtIndex:2] setTexture:[[Texture2D alloc] initWithString:name dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:12]];
	[[elements objectAtIndex:3] setTexture:[[Texture2D alloc] initWithString:constellation dimensions:CGSizeMake(128,32) alignment:UITextAlignmentLeft fontName:@"Helvetica-Bold" fontSize:9]];
	[[elements objectAtIndex:3] setBounds:CGRectMake([name sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]].width + 155, 278, 128,32)];
	info = theInfo;
	if (![self visible]) {
		[self show];
	}
}

@end
