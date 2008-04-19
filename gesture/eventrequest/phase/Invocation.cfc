<cfcomponent output="false" extends="ModelGlue.gesture.eventrequest.phase.ModuleLoadingRequestPhase"
						 hint="Runs the user's requested event."
>

<cfset this.name = "Invocation" />

<cffunction name="execute" returntype="void" output="false" hint="Executes the request phase.">
	<cfargument name="eventContext" hint="I am the event context to act upon.  Duck typed for speed.  Should have no queued events when execute() is called, but this isn't checked (to save time)." />

	<cfset var modelglue = arguments.eventContext.getModelGlue() />
	<cfset var initialEventHandlerName = arguments.eventContext.getValue(arguments.eventContext.getValue("eventValue"), modelglue.getConfigSetting("defaultEvent")) />
	<cfset var initialEventHandler = "" />

	<cfset loadModules(modelglue) />
	
	<!--- onApplicationStart --->
	<cfif request._modelglue.bootstrap.initializationRequest>
		<cfset event =  modelglue.getEventHandler("modelglue.onApplicationStart") />
		<cfset arguments.eventContext.addEventHandler(event) />
	</cfif>

	<!--- onSessionStart --->
	<cfif structKeyExists(request._modelglue.bootstrap, "sessionStart")>
		<cfset event =  modelglue.getEventHandler("modelglue.onSessionStart") />
		<cfset arguments.eventContext.addEventHandler(event) />
	</cfif>
	
	<!--- Load module and queue onRequestStart --->
	<cfset event =  modelglue.getEventHandler("modelglue.onRequestStart") />
	<cfset arguments.eventContext.addEventHandler(event) />
	
	<!--- 
	Prepare for invocation _after_ queuing onRequestStart
	
	I don't really like having to put this here, but it works. 
	--->
	<cfset arguments.eventContext.prepareForInvocation() />

	<cfset arguments.eventContext.addEventHandler(modelglue.getEventHandler(initialEventHandlerName)) />
	
	<!--- Tell the context to run its queue. --->
	<cfset arguments.eventContext.executeEventQueue() />

	<!--- Load module and queue onQueueComplete --->
	<cfset event =  modelglue.getEventHandler("modelglue.onQueueComplete") />
	<cfset arguments.eventContext.addEventHandler(event) />
</cffunction>

</cfcomponent>