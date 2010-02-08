<cfcomponent output="false" extends="ModelGlue.gesture.controller.Controller"
						 beans="modelglue.sessionFacade"
>

<cffunction name="loadPreservedState" output="false" hint="I instruct the event context to load any preserved state.">
	<cfargument name="event" />
	
	<cfset arguments.event.loadState() />
</cffunction>

<cffunction name="populateEventContext" output="false" hint="I get the list of populators and populate the event context.">
	<cfargument name="event" />
	
	<cfset var mg = arguments.event.getModelGlue() />
	<cfset var pops = mg.populators />
	<cfset var i = "" />
	
	<cfloop from="1" to="#arrayLen(pops)#" index="i">
		<cfset pops[i].populate(arguments.event) />
	</cfloop>
	
	<!--- If the "event" value isn't set, set it to the default (but don't do this for legacy apps as we may not know the defaultEvent yet). --->
	<cfif not len(arguments.event.getValue(mg.configuration.eventValue)) and (mg.configuration.versionIndicator neq "legacy")>
		<cfset arguments.event.setValue(mg.configuration.eventValue, mg.configuration.defaultEvent) />
	</cfif>
	
	<!---
	Not needed for any real use case, and causes issues with structClear().
	
	<cfset event.setValue("sessionId", beans.modelglueSessionFacade.getSessionIdentifier()) />
	--->
</cffunction>

</cfcomponent>