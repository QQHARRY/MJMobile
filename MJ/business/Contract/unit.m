//
//  unit.m
//  MJ
//
//  Created by harry on 14/12/14.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "unit.h"
#import "department.h"
#import "person.h"

@implementation unit

@synthesize isDept;
@synthesize  level;
@synthesize  superUnit;
@synthesize subDept;
@synthesize subPerson;
@synthesize closed;

-(id)init
{
    self = [super init];
    if (self)
    {
        self.subDept = [[NSMutableArray alloc ] init];
        self.subPerson = [[NSMutableArray alloc ] init];
        self.closed = YES;
    }
    return self;
}

-(BOOL)hasSubUnits
{
    return self.isDept;
}


-(long)numberOfSubUnits
{
    long iCnt = 0;
    
    
    if (!self.closed)
    {
        iCnt += self.subPerson.count + self.subDept.count;
        
        
        for (unit*subUnt in self.subDept)
        {
            iCnt += [subUnt numberOfSubUnits];
        }
        
        for (unit*subUnt in self.subPerson)
        {
            iCnt += [subUnt numberOfSubUnits];
        }
        
        
    }
    
    
    return iCnt;
}

//按照索引号查找，是不是在某个节点的子孙节点中
-(unit*)findSubUnitByIndex:(NSInteger*)index
{
    NSInteger tmpindex = *index;
    if (tmpindex == 0)
    {
        return self;
    }
    //如果这个节点是关闭的,你找别人去吧
    if (self.closed || ![self hasSubUnits])
    {
        return nil;
    }
    
    for (int i = 0; i < self.subDept.count; i++)
    {
        unit*tmpUnit = [self.subDept objectAtIndex:i];
        tmpindex--;
        unit*findedUnit = [tmpUnit findSubUnitByIndex:&tmpindex];
        
        if (findedUnit)
        {
            return findedUnit;
        }
    }
    
    for (int j = 0; j < self.subPerson.count; j++)
    {
        unit*tmpUnit = [self.subPerson objectAtIndex:j];
        tmpindex--;
        unit*findedUnit = [tmpUnit findSubUnitByIndex:&tmpindex];
        
        if (findedUnit)
        {
            return findedUnit;
        }
    }
    
    *index = tmpindex;

    
    //找遍了,没找到
    return nil;
}

-(unit*)findSuperUnitOfUnit:(unit*)unt
{
    if (unt == nil)
    {
        return nil;
    }
    
    if ([self  isKindOfClass:[department class]] )
    {
        if (self == [department rootUnit])
        {
            if ([((department*)unt).dept_parent_no isEqualToString:@"DEPT_NO000000"])
            {
                return self;
            }
        }
    }
    else
    {
        if (self == [department rootUnit])
        {
            if ([((person*)unt).department_no isEqualToString:@"DEPT_NO000000"])
            {
                return self;
            }
        }
    }
    
    if ([self  isKindOfClass:[department class]] )
    {
        if ([unt isKindOfClass:[department class]])
        {
            if ([((department*)self).dept_current_no isEqualToString:((department*)unt).dept_parent_no])
            {
                return self;
            }
            
        }
        else
        {
            if ([((department*)self).dept_current_no isEqualToString:((person*)unt).department_no])
            {
                return self;
            }
        }
    }
    
    for (unit*subUnt in self.subDept)
    {
        unit*finded = [subUnt findSuperUnitOfUnit:unt];
        if (finded != nil)
        {
            return finded;
        }
        
    }

    
    
    return nil;
}

-(void)setSubUnits:(NSArray*)units
{
    NSMutableArray*subUnits = [NSMutableArray arrayWithArray:units];
    if (units == nil || units.count == 0)
    {
        return;
    }
    
    while([subUnits  count] > 0)
    {
        unit*processedUnt = nil;
        for (unit* subUnt in subUnits)
        {

            unit*superUnt = [self findSuperUnitOfUnit:subUnt];
            if (superUnt)
            {

                if (subUnt.isDept)
                {
                    subUnt.level = superUnt.level+1;
                    [superUnt.subDept addObject:subUnt];
                    processedUnt = subUnt;
                    break;
                }
                else
                {
                    subUnt.level = superUnt.level+1;
                    [superUnt.subPerson addObject:subUnt];
                    processedUnt = subUnt;
                    break;
                }
                
                
            }
        }
        [subUnits removeObject:processedUnt];
        processedUnt = nil;
    }
}




@end
