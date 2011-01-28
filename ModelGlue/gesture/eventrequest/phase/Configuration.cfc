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


<cfcomponent output="false" extends="ModelGlue.gesture.eventrequest.phase.ModuleLoadingRequestPhase"
						 hint="If the application is not initialized, loads modules.  Declares the application initialized."
>

<cfset this.name = "Configuration" />

<cffunction name="load" access="private" returntype="void" output="false" hint="I perform the loading for this phase.">
	<cfargument name="eventContext" hint="I am the event context to use for loading.  Duck typed for speed.  Should have no queued events, but this isn't checked (to save time)." />
	
	<cfset var modelglue = arguments.eventContext.getModelGlue() />
	<cfset var event = "" />
	
	<cfset super.load(arguments.eventContext) />
	
	<!--- Add the newly loaded event to the queue. --->
	<cfset event =  modelglue.getEventHandler("modelglue.readyForModuleLoading") />
	<cfset arguments.eventContext.addEventHandler(event) />
	<cfset event =  modelglue.getEventHandler("modelglue.modulesLoaded") />
	<cfset arguments.eventContext.addEventHandler(event) />
	
	<!--- Tell the context to run its queue. --->
	<cfset arguments.eventContext.executeEventQueue() />
</cffunction>

<cffunction name="execute" returntype="void" output="false" hint="Executes the request phase.">
	<cfargument name="eventContext" hint="I am the event context to act upon.  Duck typed for speed.  Should have no queued events when execute() is called, but this isn't checked (to save time)." />

	<!--- This is a load-only phase: Nothing to do on execute --->
</cffunction>

</cfcomponent>
