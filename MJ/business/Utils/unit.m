//
//  unit.m
//  MJ
//
//  Created by harry on 14/12/14.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "unit.h"
#import "department.h"

@implementation unit

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
        
        for (unit*subUnt in self.subPerson)
        {
            iCnt += [subUnt numberOfSubUnits];
        }
        
        for (unit*subUnt in self.subDept)
        {
            iCnt += [subUnt numberOfSubUnits];
        }
    }
    
    
    return iCnt;
}


+(unit*)findUnitInUnit:(unit*)rootUnt ByIndex:(NSInteger)index
{
    if (index == 0)
    {
        return rootUnt;
    }
    //如果这个节点是关闭的,你找别人去吧
    if (rootUnt.closed)
    {
        return nil;
    }
    
    //计算一下是不是在这一分枝中
    long totalCount = [rootUnt numberOfSubUnits];
    //总共都没有那么多,你找别人吧
    if (totalCount < index)
    {
        
    }
    
    
    
    long subPsCnt = [rootUnt.subPerson count];
    long subDeptCnt = [rootUnt.subDept count];
    
    //如果这个节点的子节点数大于或等于index,那么肯定是子节点中的某一个
    if ((subPsCnt + subDeptCnt) > index)
    {
        //排列时将人员名单放在前面,子部门放在后面.
        //其中人员名单之间的先后顺序保持接口返回的顺序,子部门名单也一样
        //是子人员的某一个
        if (subPsCnt >= index)
        {
            return [rootUnt.subPerson objectAtIndex:index];
        }
        else
        {
            return [rootUnt.subDept objectAtIndex:index-subPsCnt];
        }
    }
    
   
    
    //找遍了,没找到
    return nil;
}



@end
