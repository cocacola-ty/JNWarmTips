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


### ToDo:

1. 事件Cell右上角添加一个小✘，点击之后删除该事件

2. 点击日历左上角今天的日期 回到今天

3. 点击某一天之后 在下面显示距离今天有多少天

4. 滑动之后 隐藏添加事件按钮


