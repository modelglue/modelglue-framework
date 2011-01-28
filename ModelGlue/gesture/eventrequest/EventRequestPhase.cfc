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


<cfcomponent output="false" hint="I represent a phase inside of an event request.  I'm basically a Command script for how this phase should execute.">

<cfset this.name = "Unknown request phase." />
<cfset this.loaded = false />

<cffunction name="setup" returntype="void" output="false" hint="I make sure the phase is loaded exactly once.">
	<cfargument name="eventContext" hint="I am the event context to use for loading.  Duck typed for speed.  Should have no queued events, but this isn't checked (to save time)." />
	<cfargument name="lockPrefix" type="string" required="true" hint="Prefix for name of lock to use for setup" />
	<cfargument name="lockTimeout" type="numeric" required="true" hint="Timeout for setup lock" />
	
	<cfif not this.loaded>
		<cflock type="exclusive" name="#arguments.lockPrefix#.phase.#this.name#.loading" timeout="#arguments.lockTimeout#">
			<!--- Load could have been completed by a thread which held the lock before this thread, so check again --->
			<cfif not this.loaded>
				<cfset load(arguments.eventContext) />
				<cfset this.loaded = true />
			</cfif>
		</cflock>
	</cfif>
</cffunction>

<cffunction name="load" access="private" returntype="void" output="false" hint="I perform the loading for this phase.">
	<cfargument name="eventContext" hint="I am the event context to use for loading.  Duck typed for speed.  Should have no queued events, but this isn't checked (to save time)." />
	<!--- 
		Custom phases: 
		
		Put things to do _before_ the first execute.
	--->
</cffunction>

<cffunction name="execute" returntype="void" output="false" hint="Executes the request phase.">
	<cfargument name="eventContext" hint="I am the event context to act upon.  Duck typed for speed.  Should have no queued events when execute() is called, but this isn't checked (to save time)." />
	
	<!--- 
		Custom phases: 
		
		Put things to do _before_ executing_ the queue here.
	--->
	
	<!--- Tell the context to run its queue. --->
	<cfset arguments.eventContext.executeEventQueue() />
	
	<!--- 
		Custom phases: 
		
		Put things to do _after_ executing_ the queue here.
	--->
</cffunction>

</cfcomponent>
