# TimiAccount
An account application to track expenditure and income with timeline and pie chart

Development language: Swift

Tools: XCode 8.3.3

Target platform: iOS 10.0

### Third-party library used

Name | Explain
--------- | -------------
SnapKit | [Autolayout with code](http://snapkit.io/docs/)
SVProgressHUD | [HUD](https://github.com/SVProgressHUD/SVProgressHUD)
ColorCube | [extract color from image](https://github.com/pixelogik/ColorCube)
Realm | [new loacl database solution](https://realm.io/docs/swift/latest/)
YYText | [Powerful text framework for iOS to display and edit rich text](https://github.com/ibireme/YYText)


### Database design

TMBill(bill)

Key | Identity | Column | Data Type | Description 
--------- | ------------- | --------------------- | ------------- | ---------
√ | √ |billID |String? |primary key
  | |  |date|String? |date of bill issue 
  |  | |remark|String? | remark 
  |   ||remarkIcon |Data? |icon in remark 
  |   ||isIncome |RealmOptional\<Bool\> |is expenditure or income
  |  ||money |RealmOptional\<Double\> |amount 
FK | |category |TMCategory |type of expenditure and income
FK | |book |TMBook |book that the bill belongs to 

TMCategory(category)

Key | Identity | Column | Data Type | Description 
--------- | ------------- | --------- | ------------- | ---------
√ | √ |categoryID |String? |primary key
  |  | |categoryImageFileName |String? |file name of icon used to represent category
 | ||categoryTitle |String? | title of category 
 |  ||isIncome |RealmOptional\<Bool\> |is expenditure or income

TMBook(book)

Key | Identity | Column | Data Type | Description 
--------- | ------------- | --------- | ------------- | ---------  
√ | √ |bookID |String? |primary key
|| |bookName |String? |title of book
 | ||imageIndex |RealmOptional\<Int\> | index of book icon
 |  ||bookImageFileName |String? |file name of book icon
 
 TMAddCategory(新增类别)
 
 Key | Identity | Column | Data Type | Description 
--------- | ------------- | --------- | ------------- | --------- 
√ | √ |categoryID |String? |primary key
  || |categoryImageFileNmae |String? |file name of category icon
 |  ||isIncome |RealmOptional\<Bool\> |is expenditure or income
 
Default categories are stored in plist file. When application is launched, it checks if table category in datebase is null. If yes, load categories in plist file and save them in datebase.

### Home Page

![image](https://github.com/yuanzhihao/TimiAccount/raw/master/screen-shot-timi/home%20page.png)

#### Header

![image](https://github.com/yuanzhihao/TimiAccount/raw/master/screen-shot-timi/header%20view.png)

There are some UI components that show statistic data. The pie chart around plus button is painted with UIBezierPath and CAShapeLayer. The code about painting pie chart is placed in TMPieView.swift. It can be reused in other modules.

#### Timeline

![image](https://github.com/yuanzhihao/TimiAccount/raw/master/screen-shot-timi/table%20view.png)

All income and expenditure are displayed in a table view. The income and expenditure are displayed in different cells that have different style. (TMTimeLineIncomeCell, TMTimeLineCostCell)

To avoid data misplacement when scrolling table view, I overwrite function prepareForReuse and set all attributes to nil.

To make timeline cross all income and expenditure, I implement protocal UIScrollViewDelegate and reset timeline's frame when I scroll table view.

![image](https://github.com/yuanzhihao/TimiAccount/raw/master/screen-shot-timi/timeline%20menu.png)

I create a timeline menu view to show menu when user clicks the category image of a income or expenditure. I don't implement the menu in cell (add button in cell), because performance would be bad. To avoid bad performance, I create one time line menu and hide it. When user clicks the category image of a income or expenditure, I move the menu view to clicked category image and show it.

### Add Bill (update bill)

![image](https://github.com/yuanzhihao/TimiAccount/raw/master/screen-shot-timi/add%20bill%20cost.png)

#### Header

![image](https://github.com/yuanzhihao/TimiAccount/raw/master/screen-shot-timi/add%20bill%20header.png)

When clicking a category in category list, there is a color replacement animation in header. First, I extract the color of category image. Then I use CABasicAnimation, UIBezierPath and CAShapeLayer to replace the color of header slowly.

<figure class="third">
    <img src="https://github.com/yuanzhihao/TimiAccount/raw/master/screen-shot-timi/cost%20category%201.png" width="300">
    <img src="https://github.com/yuanzhihao/TimiAccount/raw/master/screen-shot-timi/cost%20category%202.png" width="300">
    <img src="https://github.com/yuanzhihao/TimiAccount/raw/master/screen-shot-timi/income%20category.png" width="300">
</figure>

![](https://github.com/yuanzhihao/TimiAccount/raw/master/screen-shot-timi/choose%20date.png)

<figure class="half">
    <img src="https://github.com/yuanzhihao/TimiAccount/raw/master/screen-shot-timi/remark.png" width="300">
    <img src="https://github.com/yuanzhihao/TimiAccount/raw/master/screen-shot-timi/remark%202.png" width="300">
</figure>

### Bill detail

![](https://github.com/yuanzhihao/TimiAccount/raw/master/screen-shot-timi/detail%201.png)
