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


<cfcomponent output="false" hint="Saves and loads event context state from session._modelGluePreservedState.">

<cffunction name="init" output="false">
	<cfargument name="sessionFacade" default="#createObject("component", "ModelGlue.gesture.externaladapters.session.AdobeColdFusionSessionFacade").init()#" />

	<cfset variables.sessionFacade = arguments.sessionFacade />

	<cfreturn this />
</cffunction>

<cffunction name="save" output="false" hint="Saves state.  Fails silently if anything goes wrong.">
	<cfargument name="eventContext" output="false" hint="Event context from which state should be saved." />

	<cfset variables.sessionFacade.put("_modelgluePreservedState", arguments.eventContext.getAll()) />
	<cfset variables.sessionFacade.put("_modelgluePreservedLog", arguments.eventContext.log) />
</cffunction>

<cffunction name="load" output="false" hint="Loads state.">
	<cfargument name="eventContext" output="false" hint="Event context into which state should be loaded" />

	<cfif variables.sessionFacade.exists("_modelgluePreservedState")>
		<cfset arguments.eventContext.merge(variables.sessionFacade.get("_modelgluePreservedState")) />
		<cfset variables.sessionFacade.delete("_modelgluePreservedState") />
	</cfif>

	<cfif variables.sessionFacade.exists("_modelgluePreservedLog")>
		<cfset arguments.eventContext.log = variables.sessionFacade.get("_modelgluePreservedLog") />
		<cfset variables.sessionFacade.delete("_modelgluePreservedLog") />
	</cfif>

</cffunction>

</cfcomponent>
