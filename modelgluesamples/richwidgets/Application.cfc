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


<cfcomponent output="false">

<!--- Application settings --->
<cfset this.name = "modelgluesamples/richwidgets" />
<cfset this.sessionManagement = true>
<cfset this.sessionTimeout = createTimeSpan(0,0,30,0)>

<cffunction name="onSessionStart"  output="false">
	<!--- Not sure anyone'll ever need this...
	<cfset invokeSessionEvent("modelglue.onSessionStartPreRequest", session, application) />
	--->
	<!--- Set flag letting MG know it needs to broadcast onSessionStart before onRequestStart --->
	<cfset request._modelglue.bootstrap.sessionStart = true />
</cffunction>

<cffunction name="onSessionEnd" output="false">
	<cfargument name="sessionScope" type="struct" required="true">
	<cfargument name="appScope" 	type="struct" required="false">

	<cfset invokeSessionEvent("modelglue.onSessionEnd", arguments.sessionScope, appScope) />
</cffunction>

<cffunction name="invokeSessionEvent" output="false" access="private">
	<cfargument name="eventName" />
	<cfargument name="sessionScope" />
	<cfargument name="appScope" />

	<cfset var mgInstances = createObject("component", "ModelGlue.Util.ModelGlueFrameworkLocator").findInScope(appScope) />
	<cfset var values = structNew() />
	<cfset var i = "" />

	<cfset values.sessionScope = arguments.sessionScope />

	<cfloop from="1" to="#arrayLen(mgInstances)#" index="i">
		<cfset mgInstances[i].executeEvent(arguments.eventName, values) />
	</cfloop>
</cffunction>


</cfcomponent>
