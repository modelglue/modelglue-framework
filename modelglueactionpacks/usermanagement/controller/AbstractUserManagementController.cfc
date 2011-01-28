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

	<cffunction name="loadSecuritySettings" output="false">
		<cfargument name="event" />
		
		<cfset var events = beans.userService.listEventsWithAllowedGroups() />
		<cfset var eventMap = structNew() />
		
		<cfloop query="events">
			<cfif	not structKeyExists(eventMap, events.eventName)>
				<cfset eventMap[events.eventName] = structNew() />
			</cfif>
			
			<cfif not structKeyExists(eventMap[events.eventName], events.groupId)>
				<cfset eventMap[events.eventName][events.groupId] = events.groupName />
			</cfif>
		</cfloop>
		
		<cfset variables.eventMap = eventMap />
	</cffunction>
	
	<!--- Helper function:  Is a user in a group that has access to a given event? --->
	<cffunction name="userHasAccessToEvent" output="false">
		<cfargument name="user" />
		<cfargument name="eventName" />
		
		<cfset var groupId = "" />
		<cfset var groupFound = false />
		
		<cfloop collection="#variables.eventMap[arguments.eventName]#" item="groupId">
			<cfif arguments.user.isInGroup(groupId)>
				<cfset groupFound = true />
				<cfbreak />
			</cfif>
		</cfloop>
		
		<cfreturn groupFound />
	</cffunction>

</cfcomponent>
