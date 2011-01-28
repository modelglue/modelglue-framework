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

<cfset this.coldspringPath = "/modelgluetests/unittests/gesture/ColdSpring.xml">

<cffunction name="testSettingDisableDebugInAFewWays" returntype="void" access="public">
	<cfset var mg = createModelGlue(this.coldspringPath) />
	<cfset var loader = "" />
	<cfset var obj = "" />
	<cfset var beanFactory = "" />
	<cfset var ec ="" />
	<cfset beanFactory = mg.getInternalBeanFactory() />
	<cfset beanFactory.loadBeans(expandPath("/modelgluetests/unittests/gesture/externaladapters/beaninjection/ColdSpring.xml")) />
	
	<cfset loader = mg.getInternalBean("modelglue.ModuleLoaderFactory").create("XML") />
	
	<cfset loader.load(mg, "/ModelGlue/gesture/modules/internal/utility/config/utility.xml") />
	<cfset loader.load(mg, "/modelgluetests/unittests/gesture/module/disableDebugXmlModule.xml") />

	<cfparam name="request.modelGlueSuppressDebugging" default="false" >
	<cfset structClear(url) />	
	<cfset url.event = "PlainEventHandlerWithDebugNotSet" />
	<cfset ec = mg.handleRequest() />
	<cfset assertTrue( request.modelGlueSuppressDebugging IS false, "Disable Debug setting did not default to false") />
	<cfset structClear(url) />	
	<cfset url.event = "PlainEventHandlerWithDebugFalse" />
	<cfset ec = mg.handleRequest() />
	<cfset assertTrue( request.modelGlueSuppressDebugging IS false, "Disable Debug setting did not set to false naturally") />
	<cfset request.modelGlueSuppressDebugging = false />
	<cfset structClear(url) />	
	<cfset url.event = "eventHandlerWithDisabledDebug" />
	<cfset ec = mg.handleRequest() />
	<cfset assertTrue( request.modelGlueSuppressDebugging IS true, "Disable Debug setting did not work when modelglue.disableModelGlueDebugging was broadcast") />
	<cfset request.modelGlueSuppressDebugging = false />
	<cfset structClear(url) />	
	<cfset url.event = "eventHandlerWithEventTypeOfDisabledDebug" />
	<cfset ec = mg.handleRequest() />
	<cfset assertTrue( request.modelGlueSuppressDebugging IS true, "Disable Debug setting did not work when event type had modelglue.disableModelGlueDebugging broadcast ") />
	<cfset structClear(url) />	
	
	<!--- If we don't throw error, we made it. --->
</cffunction>


</cfcomponent>
