//
//	SRStar.m
//
//  A part of Sterren.app, planetarium iPhone application.
//  Created by: Jan-Willem Buurlage and Thijs Scheepers
//  Copyright 2006-2009 Mote of Life. All rights reserved.
//
//  Use without premission by Mote of Life is not authorised.
//
//  Mote of Life is a registred company at the Dutch Chamber of Commerce.
//  Chamber of Commerce registration number: 37126951
//

#import "SRStar.h"
#import "SRSettingsManager.h"
#import "SterrenAppDelegate.h"

@implementation SRStar

@synthesize name,bayer,position,mag,starID,ci,selected,hip,gliese;

- (void) dealloc {
	[name release];
	[bayer release];
	/* [x release];
	[y release];
	[z release]; */
	//[mag release];
	//[ci release];
	//[starID release];
	[super dealloc];
}

-(BOOL)visibleWithZoom:(float)zoomf {
	/*
	 if([[star mag] floatValue] < 2) {
	 ++starSizeNumTmp[0];
	 }
	 else if ([[star mag] floatValue] < 3) {
	 starSizeNumTmp[1] += 1;
	 }
	 else if ([[star mag] floatValue] < 4) {
	 starSizeNumTmp[2] += 1;
	 }
	 else if ([[star mag] floatValue] < 4.5) {
	 starSizeNumTmp[3] += 1;
	 }
	 else if ([[star mag] floatValue] < 5) {
	 starSizeNumTmp[4] += 1;
	 }
	 else if ([[star mag] floatValue] < 7) {
	 starSizeNumTmp[5] += 1;
	 }
	 */
	
	/*
	 
	 size = 4 * [camera zoomingValue] * [[appDelegate settingsManager] brightnessFactor];
	 if(size > 5) { size = 5; }
	 glPointSize(size);
	 glDrawArrays(GL_POINTS, 0, [[starSizeNum objectAtIndex:0] intValue]);
	 
	 size = 3 * [camera zoomingValue] * [[appDelegate settingsManager] brightnessFactor];
	 if(size > 4) { size = 4; }
	 glPointSize(size);
	 glDrawArrays(GL_POINTS, [[starSizeNum objectAtIndex:0] intValue], [[starSizeNum objectAtIndex:1] intValue]);
	 
	 size = 2 * [camera zoomingValue] * [[appDelegate settingsManager] brightnessFactor];
	 if(size > 3) { size = 3; }
	 glPointSize(size);
	 glDrawArrays(GL_POINTS, [[starSizeNum objectAtIndex:0] intValue] + [[starSizeNum objectAtIndex:1] intValue], [[starSizeNum objectAtIndex:2] intValue]);
	 
	 size = 0.8 * [camera zoomingValue] * [[appDelegate settingsManager] brightnessFactor];
	 if(size > 3) { size = 3; }
	 if(size < 1) { return; }
	 glPointSize(size);
	 glDrawArrays(GL_POINTS, [[starSizeNum objectAtIndex:0] intValue] + [[starSizeNum objectAtIndex:1] intValue] + [[starSizeNum objectAtIndex:2] intValue], [[starSizeNum objectAtIndex:3] intValue]);
	 
	 size = 0.5 * [camera zoomingValue] * [[appDelegate settingsManager] brightnessFactor];
	 if(size > 3) { size = 3; }
	 if(size < 1) { return; }
	 glPointSize(size);
	 glDrawArrays(GL_POINTS, [[starSizeNum objectAtIndex:0] intValue] + [[starSizeNum objectAtIndex:1] intValue] + [[starSizeNum objectAtIndex:2] intValue] + [[starSizeNum objectAtIndex:3] intValue], [[starSizeNum objectAtIndex:4] intValue]);
	 
	 size = 0.4 * [camera zoomingValue] * [[appDelegate settingsManager] brightnessFactor];
	 if(size > 3) { size = 3; }
	 if(size < 1) { return; }
	 */
	
	float size = [self size];
	id appDelegate = [[UIApplication sharedApplication] delegate]; 
	//float zoomf = [[[[appDelegate glView] delegate] camera] zoomingValue]; 
	float brightnessf = [[appDelegate settingsManager] brightnessFactor]; 
	//NSLog(@"Star visible:%f",zoomf * brightnessf * size);
	if ((zoomf * brightnessf * size) >= 1) {
		return YES;
	}
	else {
		return NO;
	}
}

-(float)size {
	float size;
	if(mag < 3) {
		size = 4.0;
	}
	else if(mag < 3) {
		size = 3.0;
	}
	else if(mag < 4) {
		size = 2.0;
	}
	else if(mag < 4.5) {
		size = 0.8;
	}
	else if(mag < 5) {
		size = 0.5;
	}
	else {
		size = 0.4;
	}
	return size;
}

-(StarColor)color {
	//http://en.wikipedia.org/wiki/Color_index
	//http://domeofthesky.com/clicks/bv.html
	//color index: lager: blauwer, hoger: roder
	StarColor color;
	if(ci > 1.2) {
		//rood
		color = StarColorMake(1.0f, 0.9f, 0.9f, [self alpha]);
	}
	else if(ci > 0.7) {
		//oranje
		color = StarColorMake(1.0, 0.925f, 0.875f, [self alpha]);
	}
	else if(ci > 0.5) {
		//geel
		color = StarColorMake(1.0f, 1.0f, 0.9f, [self alpha]);
	}
	else if(ci > 0.25) {
		//geelachtig
		color = StarColorMake(1.0f, 1.0f, 0.95f, [self alpha]);
	}
	else if(ci > 0.0) {
		//wit
		color = StarColorMake(1.0f, 1.0f, 1.0f, [self alpha]);
	}
	else {
		//blauw
		color = StarColorMake(0.9f, 0.9f, 1.0f, [self alpha]);
	}
	
	return color;
}

-(float)alpha {
	float alpha;
	if(mag < 1) {
		alpha = 1.0;
	}
	else if(mag < 2) {
		alpha = 0.7;
	}
	else if(mag  < 3) {
		alpha = 0.5;
	}
	else if(mag  < 4) {
		alpha = 0.4;
	}
	else {
		alpha = 0.3;
	}
	return alpha;
}

-(Vertex3D)myCurrentPosition {
	
	float brX = position.x;
	float brY = position.y;
	float brZ = position.z;
	
	SterrenAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
	float latitude = [[appDelegate location] latitude];
	float longitude = [[appDelegate location] longitude];
	float time = [[appDelegate timeManager] elapsed];
	
	float rotationY = -(90-latitude)*(M_PI/180);
	float rotationZ1 = -longitude*(M_PI/180);
	float rotationZ2 = -time*(M_PI/180);
	
	float maX,maY,maZ;
	
	// Matrix vermenigvuldiging met draai om de  z-as (tijd)
	maX = (cos(rotationZ2)*brX+(-sin(rotationZ2)*brY)+0*brZ);
	maY = (sin(rotationZ2)*brX+cos(rotationZ2)*brY+0*brZ);
	maZ = (0*brX+0*brY+1*brZ);
	
	brX = maX;
	brY = maY;
	brZ = maZ;
	
	// Matrix vermenigvuldiging met draai om de  z-as (locatie)
	maX = (cos(rotationZ1)*brX+(-sin(rotationZ1)*brY)+0*brZ);
	maY = (sin(rotationZ1)*brX+cos(rotationZ1)*brY+0*brZ);
	maZ = (0*brX+0*brY+1*brZ);
	
	brX = maX;
	brY = maY;
	brZ = maZ;
	
	// Matrix vermenigvuldiging met draai om de y-as (locatie)
	maX = (cos(rotationY)*brX+0*brY+sin(rotationY)*brZ);
	maY = (0*brX+1*brY+0*brZ);
	maZ = ((-sin(rotationY)*brX)+0*brY+cos(rotationY)*brZ);
	
	brX = maX;
	brY = maY;
	brZ = maZ;
	
	Vertex3D result = Vertex3DMake(-brX/20, -brY/20, -brZ/20);
	
	//NSLog(@"Geroteerde locatie ster berekend x:%f y:%f z:%f",-brX/20,-brY/20,-brZ/20);
	
	return result;
}

-(Vertex3D)position {
	return position;
}

@end