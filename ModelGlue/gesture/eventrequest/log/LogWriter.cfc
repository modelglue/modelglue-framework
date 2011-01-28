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


<cfcomponent output="false" hint="Handles writing of log entries to an EventContext.">

<cffunction name="init" output="false">
	<cfargument name="debugMode" type="string" required="true"/>
	<cfset variables.debugMode = arguments.debugMode />
	<cfreturn this />
</cffunction>

<cffunction name="write" output="false">
	<cfargument name="eventContext" />
	<cfargument name="logMessage" />
	
	<!---
		We want to log complex values when debug is set to verbose so convert it to a simple value with dump.
	 --->
	<cfif variables.debugMode IS "verbose" AND isSimpleValue(arguments.logMessage.message) IS false >
		<cfsavecontent variable="arguments.logMessage.message"><cfdump var="#arguments.logMessage.message#" /></cfsavecontent>
	</cfif>
	
	<!--- 
		Log simple values when debug isn't disabled'
	 --->
	<cfif variables.debugMode IS NOT "none" AND isSimpleValue(arguments.logMessage.message) IS true >	
		<cfset arrayAppend(eventContext.log, arguments.logMessage) />	
	</cfif>
	
</cffunction>


</cfcomponent>
