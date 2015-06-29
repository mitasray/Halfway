/*
 * This tests the current location as 2650 Haste Street (Unit 2) 
 * and friend's location as 2301 Bancroft Way (RSF). The result 
 * should be Top Dog, 2534 Durant Ave.
 */

var target = UIATarget.localTarget();
var coordinates = {};
coordinates["latitude"] = 37.866287;
coordinates["longitude"] = -122.255251;
target.setLocation(coordinates);

var mainWindow = target.frontMostApp().mainWindow();

var friendAddress = mainWindow.textFields()[0];
var friendCity = mainWindow.textFields()[1];
var friendState = mainWindow.textFields()[2];

friendAddress.setValue("2301 Bancroft Way");
friendCity.setValue("Berkeley");
friendState.setValue("CA");

var halfwayButton = mainWindow.buttons()[0];
halfwayButton.tap();
target.delay(2)
halfwayButton.tap(); // This second tap is required because of the closure error.

var resultLocation = mainWindow.staticTexts()[2];
var resultAddress = mainWindow.staticTexts()[4];

if (resultLocation.value() == "Top Dog") {
    UIALogger.logPass("Result Location is CORRECT.");
} else {
    UIALogger.logFail("Result Location is INCORRECT.");
}

if (resultAddress.value() == "2534 Durant Ave") {
    UIALogger.logPass("Result Address is CORRECT.");
} else {
    UIALogger.logFail("Result Address is INCORRECT.");
}

