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