//
//  MGBuildDate.m
//  SabadBan
//
//  Created by PC22 on 9/11/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

#import "MGBuildDate.h"

@implementation MGBuildDate

NSString *compileDate() {

    return [NSString stringWithFormat:@__DATE__];
}

NSString *compileTime() {
    return [NSString stringWithFormat:@__TIME__];
}

@end
