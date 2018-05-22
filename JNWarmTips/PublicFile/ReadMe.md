#### 布局

1. 第一部分：显示今天的日期

containerView :
    top:0 , left:0 right:0 height:84
    backColor : white

currentDateLabel :
    font : 26 bold courier
    left : 15 , top : 0 , bottom : 0
    textColor : 255,54,79 / FF364F

2. 第二部分：星期排列

  weekview :
    top : 0 , left : 0 , right : 0 , height : 30
    backColor : white

  everyWeekDayLabel:
    等宽排列
    font : 14 Menlo
    textColor : 9C9C9C

3. 第三部分 ：日期显示部分 CollectionView

    dateLabel :
        font : Menlo 14 bold


4. 第四部分 ： 事件列表 tableView

  tableView :
    top ：0 ， left : 0 , right : 0 , bottom : 0
    backColor : clearColor

  tableViewCell :
    height : 90 (default)
    backColor : clearColor

  backGroundView :
    height : 70 (default)  = timeLabelTopMargin:15 + timeLabelHeight + eventInfoLabelTopMargin:10 + eventInfoLabelHeight + eventInfoLabelBottomMargin:15
    backColor : white
    cornerRadius : 8

  timeLabel :
    left : 30 ; top : 15
    font : 12
    color : 9C9C9C

  eventInfoLabel :
    left : 30 ; bottom : 15 ; top : 10 ; right : 15
    font : 14
    color : 383838

  dotLabel :
    width : 8 height : 8
    corner : 4
    left : 11 centerY == timeLabelY
    color : red blue yello ... random

***

### Introduction

1. 日历中创建的是事件或待办任务。默认是事件。日期为当前日历所选择的日期。    
    作为事件，只需要记录事件内容和事件日期。    
    作为任务，则需要多记录任务时间或时间段。    

2. 清单中创建的可以是待办任务或纯为清单。日期的默认值为当前日期。而当选择了时间之后，更新日期为起始时间的日期。
    作为待办任务。需要有时间或时间段。可以有分组和标签。
    作为清单，不需要有时间。可以有分组和标签。

3. 从日历中向清单中同步的时候，直接将数据同步到清单表即可。    
   而从清单向日历中同步的时候，至少需要有日期值。否则在日历中将不知道哪一天显示这项内容。

4. 需要同步到清单的时候 发个通知 由清单来管理数据的插入

### ToDo:

1. 事件Cell右上角添加一个小✘，点击之后删除该事件

2. 点击日历左上角今天的日期 回到今天

3. 点击某一天之后 在下面显示距离今天有多少天

4. ~~滑动之后 隐藏添加事件按钮~~ 

5. ~~输入框没有内容的时候退出就不弹框了~~

6. cellWillDisplay 添加cell出现动画


### list

加标签，通过标签分类

加提醒时间

是否同步到日历

### Issue:

启动之后没有自动滑动到当前月
