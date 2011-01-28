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


<cfcomponent output="false" extends="ModelGlue.gesture.controller.Controller">

<cffunction name="onRequestStart" access="public" output="false" returntype="void">
	<cfargument name="event" type="any" required="true" />
	
	<cfset var onRequestStartCount = arguments.event.getValue("onRequestStartCount", 0)>
	<cfset onRequestStartCount = onRequestStartCount + 1>
	
	<cfset arguments.event.setValue("onRequestStart", "Internal onRequestStart invoked") />
	<cfset arguments.event.setValue("onRequestStartCount", onRequestStartCount) />
</cffunction>

<cffunction name="onQueueComplete" access="public" output="false" returntype="void">
	<cfargument name="event" type="any" required="true" />
	
	<cfset var onQueueCompleteCount = arguments.event.getValue("onQueueCompleteCount", 0)>
	<cfset onQueueCompleteCount = onQueueCompleteCount + 1>
	
	<cfset arguments.event.setValue("onQueueComplete", "Internal onQueueComplete invoked") />
	<cfset arguments.event.setValue("onQueueCompleteCount", onQueueCompleteCount) />
</cffunction>

<cffunction name="onRequestEnd" access="public" output="false" returntype="void">
	<cfargument name="event" type="any" required="true" />
	
	<cfset var onRequestEndCount = arguments.event.getValue("onRequestEndCount", 0)>
	<cfset onRequestEndCount = onRequestEndCount + 1>
	
	<cfset arguments.event.setValue("onRequestEnd", "Internal onRequestEnd invoked") />
	<cfset arguments.event.setValue("onRequestEndCount", onRequestEndCount) />
</cffunction>

<cffunction name="customOnRequestStart" access="public" output="false" returntype="void">
	<cfargument name="event" type="any" required="true" />
	
	<cfset arguments.event.setValue("customOnRequestStart", "Custom onRequestStart invoked") />
</cffunction>

<cffunction name="caseTest" access="public" output="false" returntype="void">
	<cfargument name="event" type="any" required="true" />
	
	<cfset arguments.event.setValue("caseTest", "caseTest invoked") />
</cffunction>

<cffunction name="testMessage" access="public" output="false" returntype="void">
	<cfargument name="event" type="any" required="true" />
	
	<cfset arguments.event.setValue("testMessage", "testMessage invoked") />
</cffunction>

</cfcomponent>
