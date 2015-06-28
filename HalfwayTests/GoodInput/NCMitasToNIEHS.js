/*
 * This tests the current location as 519 Hickorywood Blvd (Mitas's NC 
 * House) and friend's location as 111 TW Alexander Dr (NIEHS). The 
 * result should be Top Dog, 2534 Durant Ave.
 */

function NCMitasToNIEHS() {
	var target = UIATarget.localTarget();
	var coordinates = {}
	coordinates["latitude"] = 35.792614
	coordinates["longitude"] = -78.854983
	target.setLocation(coordinates)

	var mainWindow = target.frontMostApp().mainWindow();

	var friendAddress = mainWindow.textFields()[0];
	var friendCity = mainWindow.textFields()[1];
	var friendState = mainWindow.textFields()[2];

	friendAddress.setValue("111 TW Alexander Dr");
	friendCity.setValue("RTP");
	friendState.setValue("NC");

	var halfwayButton = mainWindow.buttons()[0];
	halfwayButton.tap();
	target.delay(2)
	halfwayButton.tap(); // This second tap is required because of the closure error.

	var resultLocation = mainWindow.staticTexts()[2];
	var resultAddress = mainWindow.staticTexts()[4];

	if (resultLocation.value() == "Two Guys Grille") {
	    UIALogger.logPass("Result Location is CORRECT.");
	} else {
	    UIALogger.logFail("Result Location is INCORRECT.");
	}

	if (resultAddress.value() == "4149 Davis Dr") {
	    UIALogger.logPass("Result Address is CORRECT.");
	} else {
	    UIALogger.logFail("Result Address is INCORRECT.");
	}
}

NCMitasToNIEHS()
