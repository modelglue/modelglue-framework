<cfcomponent output="false" extends="ModelGlue.gesture.controller.Controller" beans="modelglue.sessionFacade">

<cffunction name="loadPreservedState" output="false" hint="I instruct the event context to load any preserved state.">
	<cfargument name="event" />
	
	<cfset arguments.event.loadState() />
</cffunction>

<cffunction name="populateEventContext" output="false" hint="I get the list of populators and populate the event context.">
	<cfargument name="event" />
	
	<cfset var pops = arguments.event.getModelGlue().populators />
	<cfset var i = "" />
	
	<cfloop from="1" to="#arrayLen(pops)#" index="i">
		<cfset pops[i].populate(arguments.event) />
	</cfloop>
	
	<cfset event.setValue("sessionId", beans.modelglueSessionFacade.getSessionIdentifier()) />
</cffunction>

</cfcomponent>