<cfcomponent output="false" extends="ModelGlue.gesture.eventrequest.phase.ModuleLoadingRequestPhase"
						 hint="Populates the event context."
>

<cfset this.name = "Population" />

<cffunction name="execute" returntype="void" output="false" hint="Executes the request phase.">
	<cfargument name="eventContext" hint="I am the event context to act upon.  Duck typed for speed.  Should have no queued events when execute() is called, but this isn't checked (to save time)." />
	
	<cfset var modelglue = arguments.eventContext.getModelGlue() />
	<cfset var event = "" />
	
	<!--- Add the newly loaded event to the queue. --->
	<cfset event =  modelglue.getEventHandler("modelglue.onEventContextCreation") />
	<cfset arguments.eventContext.addEventHandler(event) />
	
	<!--- Tell the context to run its queue. --->
	<cfset arguments.eventContext.executeEventQueue() />

	<cfset event =  modelglue.getEventHandler("modelglue.onEventContextPopulation") />
	<cfset arguments.eventContext.addEventHandler(event) />
</cffunction>

</cfcomponent>