# The second of every two lines is the script filepath. 
# Needs to be changed when new tests added. 
# The first line remains the same for every test.

# GoodInput/Unit2ToRSF.js
instruments -w 260DEAE5-EEF4-4F21-9967-7CED7BA4969 -t "/Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/PlugIns/AutomationInstrument.xrplugin/Contents/Resources/Automation.tracetemplate" Halfway -e UIARESULTSPATH $HOME/Xcode\ Projects/Halfway/HalfwayTests/AutomatedTests/TestResults/ -e UIASCRIPT \
$HOME/Xcode\ Projects/Halfway/HalfwayTests/AutomatedTests/GoodInput/Unit2ToRSF.js

# BadInput/Unit2ToBadAddress.js
instruments -w 260DEAE5-EEF4-4F21-9967-7CED7BA4969 -t "/Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/PlugIns/AutomationInstrument.xrplugin/Contents/Resources/Automation.tracetemplate" Halfway -e UIARESULTSPATH $HOME/Xcode\ Projects/Halfway/HalfwayTests/AutomatedTests/TestResults/ -e UIASCRIPT \
$HOME/Xcode\ Projects/Halfway/HalfwayTests/AutomatedTests/BadInput/Unit2ToBadAddress.js

# BadInput/Unit2ToBadCity.js
instruments -w 260DEAE5-EEF4-4F21-9967-7CED7BA4969 -t "/Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/PlugIns/AutomationInstrument.xrplugin/Contents/Resources/Automation.tracetemplate" Halfway -e UIARESULTSPATH $HOME/Xcode\ Projects/Halfway/HalfwayTests/AutomatedTests/TestResults/ -e UIASCRIPT \
$HOME/Xcode\ Projects/Halfway/HalfwayTests/AutomatedTests/BadInput/Unit2ToBadCity.js

# BadInput/Unit2ToBadCity.js
instruments -w 260DEAE5-EEF4-4F21-9967-7CED7BA4969 -t "/Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/PlugIns/AutomationInstrument.xrplugin/Contents/Resources/Automation.tracetemplate" Halfway -e UIARESULTSPATH $HOME/Xcode\ Projects/Halfway/HalfwayTests/AutomatedTests/TestResults/ -e UIASCRIPT \
$HOME/Xcode\ Projects/Halfway/HalfwayTests/AutomatedTests/BadInput/Unit2ToBadState.js

