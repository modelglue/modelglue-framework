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


<cfcomponent output="false" extends="ModelGlue.gesture.controller.Controller" beans="modelglue.eventGenerator,CFUniFormConfigBean,modelglue.eventGeneratorConfig">

<cffunction name="loadCFUniformConfig" output="false" access="public" returntype="void" hint="">
	<cfargument name="event" />
	<cfset event.setValue("CFUniformConfig", duplicate(beans.CFUniFormConfigBean)) />
</cffunction>

<cffunction name="loadEventGenerationConfig" output="false" access="public" returntype="void" hint="">
	<cfargument name="event" />
	<cfset event.setValue("eventGenerationConfig", duplicate(beans.modelglueEventGeneratorConfig)) />
</cffunction>

<cffunction name="getEventHandlerNames" output="false" access="public" returntype="void" hint="">
	<cfargument name="event" />
	
	<cfset var moduleLoaderArray = getModelGlue().getModuleLoaderArray() />
	<cfset var moduleLoader = "" />
	<cfset var i = 0 />
	<cfset var j = 0 />
	<cfset var eventHandlers = arrayNew(1) />
	<cfset var eventHandlerNames = arrayNew(1) />
	<cfset var eventHandlerName = "" />
	
	<cfloop from="1" to="#arrayLen(moduleLoaderArray)#" index="i">
		<cfset moduleLoader = moduleLoaderArray[i] />
		<cfset eventHandlers = moduleLoader.listEventHandlers() />
		
		<cfloop from="1" to="#arrayLen(eventHandlers)#" index="j">
			<cfset eventHandlerName = eventHandlers[j] />
			<cfset arrayAppend(eventHandlerNames, eventHandlerName) />
		</cfloop>
	</cfloop>
	
	<cfset arraySort(eventHandlerNames, "textnocase") />
	
	<cfset event.setValue("eventHandlerNames", eventHandlerNames) />
</cffunction>

<cffunction name="getEventTypeNames" output="false" access="public" returntype="void" hint="">
	<cfargument name="event" />
	
	<cfset var moduleLoaderArray = getModelGlue().getModuleLoaderArray() />
	<cfset var moduleLoader = "" />
	<cfset var i = 0 />
	<cfset var j = 0 />
	<cfset var eventTypes = arrayNew(1) />
	<cfset var eventTypeNames = arrayNew(1) />
	<cfset var eventTypeName = "" />
	
	<cfloop from="1" to="#arrayLen(moduleLoaderArray)#" index="i">
		<cfset moduleLoader = moduleLoaderArray[i] />
		<cfset eventTypes = moduleLoader.listeventTypes() />
		
		<cfloop from="1" to="#arrayLen(eventTypes)#" index="j">
			<cfset eventTypeName = eventTypes[j] />
			<cfset arrayAppend(eventTypeNames, eventTypeName) />
		</cfloop>
	</cfloop>
	
	<cfset event.setValue("eventTypeNames", eventTypeNames) />
</cffunction>

<cffunction name="generateEvent" output="false" hint="If the requested event doesn't exist, I generate its XML as well as code stubs for a listener and a view.">
	<cfargument name="event" />
	
	<cfset var eventName = arguments.event.getValue(arguments.event.getValue("eventValue")) />
	
	<cfif getModelGlue().getConfigSetting("generationEnabled") and not getModelGlue().hasEventHandler(eventName)>
		
		<cfif not arguments.event.exists("generateView")>
			<cfset arguments.event.setValue("eventName", eventName) />
			
			<cfset arguments.event.forward(eventName="modelglue.generateEvent", append="eventName", preserveState="false") />
		<cfelse>
			<cfset event.addTraceStatement("Event Generation", "Generating ""#eventName#""") />
			
			<cfset beans.modelglueEventGenerator.generateEvent(arguments.event) />
			
			<cfset arguments.event.removeValue("generateView") />
			
			<cfset arguments.event.addResult("configurationInvalidated") />
		</cfif>
	</cfif>
</cffunction>

</cfcomponent>