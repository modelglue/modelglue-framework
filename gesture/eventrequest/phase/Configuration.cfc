<cfcomponent output="false" extends="ModelGlue.gesture.eventrequest.phase.ModuleLoadingRequestPhase"
						 hint="If the application is not initialized, loads modules.  Declares the application initialized."
>

<cfset this.name = "Configuration" />

<cffunction name="execute" returntype="void" output="false" hint="Executes the request phase.">
	<cfargument name="eventContext" hint="I am the event context to act upon.  Duck typed for speed.  Should have no queued events when execute() is called, but this isn't checked (to save time)." />
	
	<cfset var modelglue = arguments.eventContext.getModelGlue() />
	<cfset var event = "" />
	
	<!--- 
		Before event queue runs, we need to load any configured modules.
	--->
	<cfset loadModules(modelglue) />
	
	<!--- Add the newly loaded event to the queue. --->
	<cfset event =  modelglue.getEventHandler("modelglue.readyForModuleLoading") />
	<cfset arguments.eventContext.addEventHandler(event) />
	
	<!--- Tell the context to run its queue. --->
	<cfset arguments.eventContext.executeEventQueue() />
</cffunction>

</cfcomponent>