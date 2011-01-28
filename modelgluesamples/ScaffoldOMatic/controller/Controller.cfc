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


<cfcomponent output="false" hint="I am a Model-Glue controller." 
	extends="ModelGlue.gesture.controller.Controller"
	beans="CFUniFormConfigBean">

	<cffunction name="onRequestStart" output="false" access="public" returntype="void" hint="">
		<cfargument name="event">
		<cfset arguments.event.setValue("UserMsg", createobject("component", "ScaffoldOMatic.model.UserMessageContainer").init()  ) />
		<cfset arguments.event.setValue("CFUniFormConfig", duplicate(beans.CFUniFormConfigBean) ) />
		<cfset arguments.event.setValue("CurrentPage", createobject("component", "ScaffoldOMatic.model.CurrentPage").init(eventName:event.getValue(event.getValue("eventValue" ) ) ) ) />
	</cffunction>

	
</cfcomponent>
	
