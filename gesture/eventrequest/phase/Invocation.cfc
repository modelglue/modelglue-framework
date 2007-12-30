<cfcomponent output="false" extends="ModelGlue.gesture.eventrequest.phase.ModuleLoadingRequestPhase"
						 hint="Runs the user's requested event."
>

<cfset this.name = "Invocation" />

<cffunction name="execute" returntype="void" output="false" hint="Executes the request phase.">
	<cfargument name="eventContext" hint="I am the event context to act upon.  Duck typed for speed.  Should have no queued events when execute() is called, but this isn't checked (to save time)." />

	<cfset var modelglue = arguments.eventContext.getModelGlue() />
	<cfset var initialEventHandlerName = arguments.eventContext.getValue(arguments.eventContext.getValue("eventValue")) />
	<cfset var initialEventHandler = "" />

	<!--- Load module and queue onRequestStart --->
	<cfset loadModules(modelglue) />
	
	<!--- Add the newly loaded event to the queue. --->
	<cfset event =  modelglue.getEventHandler("modelglue.onRequestStart") />
	<cfset arguments.eventContext.addEventHandler(event) />
	
	<!--- Determine and queue the initial event handler --->	
	<cfif len(initialEventHandlerName)>
		<cfset initialEventHandler = modelglue.getEventHandler(initialEventHandlerName) />
	<cfelse>
		<cfset initialEventHandler = modelglue.getEventHandler(modelglue.getConfigSetting("defaultEvent")) />
	</cfif>

	<cfset arguments.eventContext.addEventHandler(initialEventHandler) />
	
	<!--- Tell the context to run its queue. --->
	<cfset arguments.eventContext.executeEventQueue() />
		
</cffunction>

</cfcomponent>