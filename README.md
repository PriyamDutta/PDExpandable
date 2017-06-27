# PDExpandable
A light Expandable UITableView basically designed for the use of Add ons for a particular listing at index.

# Screen Shot
![alt tag](https://github.com/PriyamDutta/PDExpandable/blob/master/Expand.png)

# Usability

Addons can be added to the respective listing index at a time. You can delete the addons by hitting red buttons. For the time being it is restricted to at least one addon to be kept added if you started adding. After filling textfield you will have a model of data you have added and use it further.

You can directly pass by hitting on any index without adding addons. But if you have addons you have to press OK button in the last row.

# Get your mapped data
```
let dataModel = DataModel()
dataModel.addOnArray = (weakSelf?.extendCellCollection)!
dataModel.dataDict = mainArray[selectedSecton] as! [String : String]
```
