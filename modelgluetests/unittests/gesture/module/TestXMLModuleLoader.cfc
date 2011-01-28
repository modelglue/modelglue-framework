<!---
LICENSE INFORMATION:

Copyright 2011, Joe Rinehart, Dan Wilson

Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. 

You may obtain a copy of the License at 

	http://www.apache.org/licenses/LICENSE-2.0 
	
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.

VERSION INFORMATION:

This file is part of @versionLabel@ (@versionNumber@).

The version number in parentheses is in the format versionNumber.subversion.revisionNumber.

If the version number appears as 'versionNumber' surrounded by @ symbols
then this file is a working copy and not part of a release build.
--->


<cfcomponent extends="modelgluetests.unittests.gesture.ModelGlueAbstractTestCase">

<!--- 

	Note: These tests are really complex. If you want to try and be more performant, use the method createModelGlueIfNotDefined( this.coldSpringPath)
	BUT this has ramifications because if you are expecting predictable results, and you reuse a framework instance 
	(that has been defined) your tests can fail depending on the order in which MXunit runs them.
	
	In most cases, changing over to createModelGlue(this.coldspringPath)  will fix failing tests because the ModelGlue instance is clean, fresh and the contents are predictable.
	
	 
 --->

<cfset this.coldspringPath = "/modelgluetests/unittests/gesture/ColdSpring.xml">

<cffunction name="testSimpleXMLModule" returntype="void" access="public">
	<cfset var mg = createModelGlue(this.coldspringPath) />
	<cfset var loader = "" />
	<cfset var obj = "" />
	<cfset var controllerVars = "" />
	<cfset var beanFactory = "" />
	<cfset var ctrl = "" />
	
	<cfset mg.getInternalBeanFactory().loadBeans(expandPath("/modelgluetests/unittests/gesture/externaladapters/beaninjection/ColdSpring.xml")) />
	
	<cfset loader = mg.getInternalBean("modelglue.ModuleLoaderFactory").create("XML") />
	<cfset loader.load(mg, "/modelgluetests/unittests/gesture/module/simpleXmlModule.xml") />
	
	<!--- Test controller loading --->
	<cfset ctrl = mg.getController("controller") />
	<cfset assertTrue(mg.hasEventListener("messageName"), "No listeners for messageName found") />
	<cfset obj = mg.getEventListeners("messageName") />
	<cfset assertTrue(arrayLen(obj) eq 1, "Incorrect number of listeners found (should be 1, was #arrayLen(obj)#)") />
	<cfset obj = obj[1] />
	<cfset assertEquals("modelgluetests.unittests.gesture.module.Controller", GetMetadata(obj.target).name, "Controller not of right type") />
	<cfset assertTrue(obj.listenerFunction eq "listener", "listener function not right name") />

	<!--- Test controller bean injection / autowiring --->
	<cfset assertTrue(structKeyExists(ctrl, "_modelGlueBeanInjection_getVariablesScope"), "injection hooks not created in controller") />
	<cfset controllerVars = ctrl._modelGlueBeanInjection_getVariablesScope() />
	<cfset assertTrue(structKeyExists(controllerVars, "beans"), "beans scope not created") />
	<cfset assertTrue(structKeyExists(controllerVars.beans, "bean") and isObject(controllerVars.beans.bean), "beans.bean not existent or not object") />
	<cfset assertTrue(isObject(ctrl.getBean2()), "controller not autowired") />

	<!--- Test event handler loading --->
	<cfset obj = mg.getEventHandler("eventHandlerName") />
	<cfset assertTrue(isObject(obj), "event handler not object!") />
	
	<!--- Messages --->
	<cfset assertTrue(arrayLen(obj.messages) eq 1, "message not found or more than one message found") />

	<cfset assertTrue(obj.messages[1].name eq "messageName", "message name not set") />
	<cfset assertTrue(obj.messages[1].arguments.getValue("argumentName") eq "argumentValue", "argument value not set (result = '#obj.messages[1].arguments.getValue("argumentName")#')") />


	<!--- Results --->
	<cfset assertTrue(structCount(obj.results) eq 2, "results not found or two results not found") />
	<cfset assertTrue(arrayLen(obj.results.resultName) eq 1, "resultName result not  found or more than one result mapped") />
	<cfset assertTrue(obj.results.resultName[1].event eq "eventName", "resultName event prop misdefined") />
	<cfset assertTrue(obj.results.resultName[1].redirect, "resultName redirect prop misdefined") />
	<cfset assertTrue(obj.results.resultName[1].append eq "appendValue", "resultName append prop misdefined") />
	<cfset assertTrue(obj.results.resultName[1].anchor eq "anchorValue", "resultName anchor prop misdefined") />
	<cfset assertFalse(obj.results.resultName[1].preservestate, "resultName preservestate prop misdefined") />
	<cfset assertTrue(arrayLen(obj.results["CFNULLKEYWORKAROUND"]) eq 1, "implicit result result not  found or more than one result mapped") />
	<cfset assertTrue(obj.results["CFNULLKEYWORKAROUND"][1].event eq "implicitEventName", "implicit result event prop misdefined") />
	<cfset assertTrue(obj.results["CFNULLKEYWORKAROUND"][1].redirect, "implicit result redirect prop misdefined") />
	<cfset assertTrue(obj.results["CFNULLKEYWORKAROUND"][1].append eq "appendValue", "implicit result append prop misdefined") />
	<cfset assertTrue(obj.results["CFNULLKEYWORKAROUND"][1].anchor eq "anchorValue", "implicit result anchor prop misdefined") />
	<cfset assertFalse(obj.results["CFNULLKEYWORKAROUND"][1].preservestate, "implicit result preservestate prop misdefined") />
	
	<!--- Views --->
	<cfset assertTrue(arrayLen(obj.views) eq 1, "view not found or more than one view found") />
	<cfset assertTrue(obj.views[1].name eq "viewName", "view name not set") />
	<cfset assertTrue(obj.views[1].template eq "templateName", "view template not set") />
	<cfset assertTrue(structCount(obj.views[1].values) eq 1, "number of values is not one") />
	<cfset assertTrue(structKeyExists(obj.views[1].values, "valueName"), "value named ""valuename"" not found") />
	<cfset assertTrue(obj.views[1].values.valueName.name eq "valueName", "valueName value not named valueName (ugh, that's confusing.)") />	
	<cfset assertTrue(obj.views[1].values.valueName.value eq "valueValue", "valueName value not set to valueValue") />	
	<cfset assertFalse(obj.views[1].values.valueName.overwrite eq "valueValue", "valueName value wasn't set to not overwrite") />	
	
</cffunction>

<cffunction name="testIncludeStyleMasterXMLModule" returntype="void" access="public">
	<cfset var mg = createModelGlueIfNotDefined(this.coldspringPath) />
	<cfset var loader = "" />
	<cfset var obj = "" />
	<cfset var beanFactory = "" />
	<cfset var ctrl = "" />
	
	<cfset beanFactory = mg.getInternalBeanFactory() />
	<cfset beanFactory.loadBeans(expandPath("/modelgluetests/unittests/gesture/externaladapters/beaninjection/ColdSpring.xml")) />
	
	<cfset loader = mg.getInternalBean("modelglue.ModuleLoaderFactory").create("XML") />
	
	<cfset loader.load(mg, "/modelgluetests/unittests/gesture/module/includeStyleMasterXmlModule.xml") />
	
	<cfset ctrl = mg.getController("controller") />
	<cfset assertTrue(mg.hasEventListener("messageName"), "No listeners for messageName found") />
	<cfset obj = mg.getEventHandler("eventHandlerName") />
	<cfset assertTrue(isObject(obj), "event handler not object!") />
</cffunction>

<cffunction name="testMasterXMLModule" returntype="void" access="public">
	<cfset var mg = createModelGlueIfNotDefined(this.coldspringPath) />
	<cfset var loader = "" />
	<cfset var obj = "" />
	<cfset var beanFactory = "" />
	<cfset var ctrl = "" />
	
	<cfset beanFactory = mg.getInternalBeanFactory() />
	<cfset beanFactory.loadBeans(expandPath("/modelgluetests/unittests/gesture/externaladapters/beaninjection/ColdSpring.xml")) />
	
	<cfset loader = mg.getInternalBean("modelglue.ModuleLoaderFactory").create("XML") />
	
	<cfset loader.load(mg, "/modelgluetests/unittests/gesture/module/masterXmlModule.xml") />
	
	<cfset ctrl = mg.getController("controller") />
	<cfset assertTrue(mg.hasEventListener("messageName"), "No listeners for messageName found") />
	<cfset obj = mg.getEventHandler("eventHandlerName") />
	<cfset assertTrue(isObject(obj), "event handler not object!") />
</cffunction>

<cffunction name="testRecursiveXMLModule" returntype="void" access="public">
	<cfset var mg = createModelGlueIfNotDefined(this.coldspringPath) />
	<cfset var loader = "" />
	<cfset var obj = "" />
	<cfset var beanFactory = "" />
	
	<cfset loader = mg.getInternalBean("modelglue.ModuleLoaderFactory").create("XML") />
	
	<cfset loader.load(mg, "/modelgluetests/unittests/gesture/module/recursiveXmlModule.xml") />
	
	<!--- Not going into an infinite loop = passing. --->	
</cffunction>

<cffunction name="testRecursiveResultLoading" returntype="void" access="public">
	<cfset var mg = createModelGlue(this.coldspringPath) />
	<cfset var ec = "" />
	
	<cfset mg.setConfigSetting("primaryModule", "/modelgluetests/unittests/gesture/module/recursiveResultModule.xml")>
	
	<cfset structClear(url) />
	
	<cfset ec = mg.handleRequest() />
	
	<cfset structClear(url) />
	
	<!--- Not going into an infinite loop = passing. --->
</cffunction>

<cffunction name="testSettingParsing_arbitrary" returntype="void" access="public">
	<cfset var mg = createModelGlueIfNotDefined(this.coldspringPath) />
	<cfset var loader = "" />
	<cfset var obj = "" />
	<cfset var beanFactory = "" />
	
	<cfset beanFactory = mg.getInternalBeanFactory() />
	<cfset beanFactory.loadBeans(expandPath("/modelgluetests/unittests/gesture/externaladapters/beaninjection/ColdSpring.xml")) />
	
	<cfset loader = mg.getInternalBean("modelglue.ModuleLoaderFactory").create("XML") />

	<cfset loader.load(mg, "/modelgluetests/unittests/gesture/module/simpleXmlModule.xml") />

	<cfset assertTrue(mg.getConfigSetting("arbitrarySetting") eq "arbitrarySettingValue", "arbitrary setting not set") />
</cffunction>

 <cffunction name="testSettingParsing_viewMappings" returntype="void" access="public">
	<cfset var mg = createModelGlue(this.coldspringPath) />
	<cfset var loader = "" />
	<cfset var obj = "" />
	<cfset var viewRenderer = "" />
	<cfset var beanFactory = "" />
	<cfset var viewMappings = 0 />
	
	<cfset beanFactory = mg.getInternalBeanFactory() />
	<cfset beanFactory.loadBeans(expandPath("/modelgluetests/unittests/gesture/externaladapters/beaninjection/ColdSpring.xml")) />
	
	<cfset loader = mg.getInternalBean("modelglue.ModuleLoaderFactory").create("XML") />

	<cfset viewMappings = mg.getConfigSetting("viewMappings") />
	<cfset ArrayAppend(viewMappings, "initialViewMapping") />
	<cfset mg.setConfigSetting("viewMappings", viewMappings) />
	<cfset loader.load(mg, "/modelgluetests/unittests/gesture/module/simpleXmlModule.xml") />
	<cfset assertTrue( arrayToList( mg.getConfigSetting("viewMappings") ) eq "initialViewMapping,viewMappingsValue", "viewMappingsValue not appended (was: '#arrayToList( mg.getConfigSetting("viewMappings") )#')") />
	
	<cfset viewRenderer = mg.getInternalBean("modelglue.viewRenderer") />

	<cfset assertTrue( arrayToList(  viewRenderer.getViewMappings() ) eq "initialViewMapping,viewMappingsValue", "viewMappingsValue not in viewRenderer's mappings (was: '#arrayToList(  viewRenderer.getViewMappings() )#')") />
	
</cffunction>

<cffunction name="testSettingParsing_beanMappings_coldSpring" returntype="void" access="public">
	<cfset var mg = createModelGlueIfNotDefined(this.coldspringPath) />
	<cfset var loader = "" />
	<cfset var obj = "" />
	<cfset var beanFactory = "" />
	<cfset var viewMappings = arrayNew(1) />
	<cfset arrayAppend( viewMappings, "initialViewMapping" ) />
	<cfset beanFactory = mg.getInternalBeanFactory() />
	<cfset beanFactory.loadBeans(expandPath("/modelgluetests/unittests/gesture/externaladapters/beaninjection/ColdSpring.xml")) />
	
	<cfset loader = mg.getInternalBean("modelglue.ModuleLoaderFactory").create("XML") />
	
	<cfset mg.setConfigSetting("viewMappings", viewMappings) />
	
	<cfset loader.load(mg, "/modelgluetests/unittests/gesture/module/simpleXmlModule.xml") />
	
	<cfset obj = mg.getBean("mapCollection") />

	<!--- If we don't throw error, we made it. --->
</cffunction>


<cffunction name="testSettingExtensibleInAFewWays" returntype="void" access="public">
	<cfset var mg = createModelGlueIfNotDefined(this.coldspringPath) />
	<cfset var loader = "" />
	<cfset var obj = "" />
	<cfset var beanFactory = "" />
	
	<cfset loader = mg.getInternalBean("modelglue.ModuleLoaderFactory").create("XML") />
	<cfset loader.load(mg, "/modelgluetests/unittests/gesture/module/extensibleXmlModule.xml") />
	
	<cfset obj = mg.getEventHandler("eventHandlerWithExtensibleNotSet") />
	<cfset assertTrue( obj.extensible IS false, "Extensible setting did not default to false") />
	<cfset obj = mg.getEventHandler("eventHandlerWithExtensibleFalse") />
	<cfset assertTrue( obj.extensible IS false, "Extensible setting did not work when extensible=""false"" ") />
	<cfset obj = mg.getEventHandler("eventHandlerWithExtensibleTrue") />
	<cfset assertTrue( obj.extensible IS true, "Extensible setting did not work when extensible=""true"" ") />
	
	<!--- If we don't throw error, we made it. --->
</cffunction>

<cffunction name="testViewHelperSetting" returntype="void" access="public">
	<cfset var mg = createModelGlue("/modelgluetests/unittests/gesture/eventrequest/ColdSpring.xml") />
	<cfset var loader = "" />
	<cfset var obj = "" />
	<cfset var beanFactory = "" />
	
	<cfset beanFactory = mg.getInternalBeanFactory() />
	
	<cfset loader = mg.getInternalBean("modelglue.ModuleLoaderFactory").create("XML") />
	
	<cfset assertTrue( mg.getConfigSetting("helperMappings") IS "/I/Am/A/HelperMapping", "No initial helper mapping found, this is a config problem probably" ) />
	<cfset loader.load(mg, "/modelgluetests/unittests/gesture/module/viewMappingInSettingsXmlModule.xml") />
	<cfset assertTrue( mg.getConfigSetting("helperMappings") IS "/I/Am/A/HelperMapping,/I/Am/A/Helper/Mapping,/So/Am/I", "Helper mappings from config block not added correctly We got ""#mg.getConfigSetting("helperMappings")#"" ")>
	<!--- If we don't throw error, we made it. --->
</cffunction>
	
	
</cfcomponent>
