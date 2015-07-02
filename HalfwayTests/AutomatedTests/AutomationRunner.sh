# The second of every two lines is the script filepath. 
# Needs to be changed when new tests added. 
# The first line remains the same for every test.

# Device ID
IPHONE6="5F7D5389-DCEB-4EE3-834F-4064A6A117CC"

# Template Filepath
TEMPLATE_FILEPATH="/Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/PlugIns/AutomationInstrument.xrplugin/Contents/Resources/Automation.tracetemplate"

# App Name
APP_NAME="Halfway"

# UIA Results Filepath
# The below variable does not work when trying to run the test.
#UIARESULTS_FILEPATH="$HOME/Xcode\ Projects/Halfway/HalfwayTests/AutomatedTests/TestResults/"

# UIA Script Filepath
# The below variable does not work when trying to run the test.
#UIASCRIPT_FILEPATH="$HOME/Xcode\ Projects/Halfway/HalfwayTests/AutomatedTests/GoodInput/Unit2ToRSF.js"



# GoodInput/Unit2ToRSF.js
instruments -w $IPHONE6 \
-t $TEMPLATE_FILEPATH \
Halfway \
-e UIARESULTSPATH $HOME/Xcode\ Projects/Halfway/HalfwayTests/AutomatedTests/TestResults/ \
-e UIASCRIPT $HOME/Xcode\ Projects/Halfway/HalfwayTests/AutomatedTests/GoodInput/Unit2ToRSF.js

# BadInput/Unit2ToBadAddress.js
#instruments -w 260DEAE5-EEF4-4F21-9967-7CED7BA4969 -t "/Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/PlugIns/AutomationInstrument.xrplugin/Contents/Resources/Automation.tracetemplate" Halfway -e UIARESULTSPATH $HOME/Xcode\ Projects/Halfway/HalfwayTests/AutomatedTests/TestResults/ -e UIASCRIPT \
#$HOME/Xcode\ Projects/Halfway/HalfwayTests/AutomatedTests/BadInput/Unit2ToBadAddress.js

# BadInput/Unit2ToBadCity.js
#instruments -w 260DEAE5-EEF4-4F21-9967-7CED7BA4969 -t "/Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/PlugIns/AutomationInstrument.xrplugin/Contents/Resources/Automation.tracetemplate" Halfway -e UIARESULTSPATH $HOME/Xcode\ Projects/Halfway/HalfwayTests/AutomatedTests/TestResults/ -e UIASCRIPT \
#$HOME/Xcode\ Projects/Halfway/HalfwayTests/AutomatedTests/BadInput/Unit2ToBadCity.js

# BadInput/Unit2ToBadCity.js
#instruments -w 260DEAE5-EEF4-4F21-9967-7CED7BA4969 -t "/Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/PlugIns/AutomationInstrument.xrplugin/Contents/Resources/Automation.tracetemplate" Halfway -e UIARESULTSPATH $HOME/Xcode\ Projects/Halfway/HalfwayTests/AutomatedTests/TestResults/ -e UIASCRIPT \
#$HOME/Xcode\ Projects/Halfway/HalfwayTests/AutomatedTests/BadInput/Unit2ToBadState.js

#instruments -w $IPHONE6 \
#-t $TEMPLATE_FILEPATH \
#$APP_NAME \
#-e UIARESULTSPATH $UIARESULTS_FILEPATH \
#-e UIASCRIPT $UIASCRIPT_FILEPATH
