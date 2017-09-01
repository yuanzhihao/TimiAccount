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

#### Header
