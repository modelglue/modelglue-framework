<cfcomponent output="false" extends="ModelGlue.gesture.eventrequest.phase.ModuleLoadingRequestPhase"
						 hint="Runs the user's requested event."
>

<cfset this.name = "Invocation" />

<cffunction name="load" access="private" returntype="void" output="false" hint="I perform the loading for this phase.">
	<cfargument name="eventContext" hint="I am the event context to use for loading.  Duck typed for speed.  Should have no queued events, but this isn't checked (to save time)." />
	
	<cfset var modelglue = arguments.eventContext.getModelGlue() />
	<cfset var event = "" />
	
	<cfset super.load(arguments.eventContext) />
	
	<!--- onApplicationStart --->
	<cfset event =  modelglue.getEventHandler("modelglue.onApplicationStart") />
	<cfset arguments.eventContext.addEventHandler(event) />
</cffunction>

<cffunction name="execute" returntype="void" output="false" hint="Executes the request phase.">
	<cfargument name="eventContext" hint="I am the event context to act upon.  Duck typed for speed.  Should have no queued events when execute() is called, but this isn't checked (to save time)." />

	<cfset var modelglue = arguments.eventContext.getModelGlue() />
	<cfset var initialEventHandlerName = arguments.eventContext.getInitialEventHandlerName() />
	<cfset var initialEventHandler = "" />
	<cfset var event = "" />

	<!--- onSessionStart --->
	<cfif structKeyExists(request._modelglue.bootstrap, "sessionStart")>
		<cfset event =  modelglue.getEventHandler("modelglue.onSessionStart") />
		<cfset arguments.eventContext.addEventHandler(event) />
	</cfif>
	
	<!--- onRequestStart --->
	<cfset event =  modelglue.getEventHandler("modelglue.onRequestStart") />
	<cfset arguments.eventContext.addEventHandler(event) />

	<!--- Tell the context to run its queue. --->
	<cfset arguments.eventContext.executeEventQueue() />
	
	<!--- 
	Prepare for invocation _after_ queuing onRequestStart
	
	I don't really like having to put this here, but it works. 
	--->
	<cfset arguments.eventContext.prepareForInvocation() />

	<cfif structKeyExists(modelglue.eventHandlers, initialEventHandlerName)>
		<cfset initialEventHandler = modelglue.getEventHandler(initialEventHandlerName) />

		<!--- Initial user-requested event must be marked public. --->
		<cfif not initialEventHandler.access eq "public">
				<cfthrow message="This event-handler is private." />
		</cfif>		

		<cfset arguments.eventContext.addEventHandler(initialEventHandler) />
	<cfelseif find("&", urlDecode(initialEventHandlerName) ) GT 0 AND unwindAndForward(urlDecode(initialEventHandlerName), arguments.eventContext) IS true>
		<!--- unwindAndForward will never return true. It will redirect before it returns anything. If it can not redirect, then this branch will fail and the other branches will evaluate --->
	<cfelseif structKeyExists(modelglue.eventHandlers, modelglue.configuration.missingEvent)>
		<cfset arguments.eventContext.setValue("missingEvent", initialEventHandlerName) />
		<cfset arguments.eventContext.addEventHandler(modelglue.eventHandlers[modelglue.configuration.missingEvent]) />
	<cfelse>
		<cfthrow message="Model-Glue:  There is no known event handler for ""#initialEventHandlerName#""." />
	</cfif>	
	
	<!--- Tell the context to run its queue. --->
	<cfset arguments.eventContext.executeEventQueue(true) />

	<!--- onRequestEnd --->
	<cfset event =  modelglue.getEventHandler("modelglue.onRequestEnd") />
	<cfset arguments.eventContext.addEventHandler(event) />

	<cfset arguments.eventContext.executeEventQueue() />
</cffunction>

<cffunction name="unwindAndForward" output="false" access="private" returntype="boolean" hint="This function should unwind a munged url, add the parameters to the event scope and then redirect. If something goes wrong, it will return false">
	<cfargument name="stringOfValues" hint="If this is being used, then some bag of crap was not able to be decoded into individual form parameters. This happens at times, like when a link gets URL encoded in an email and someone pastes it." />
	<cfargument name="eventContext" hint="the current EventContext. Duck typed for speed. We use this to get a handle on the forward method" />
	<cfset var tempScope = structNew() />
	<cfset var EventName = "" />
	<cfset var thisParamSet = "" />
	<cfset var paramName = "" />
	<cfset var paramValue = "" />
	
	<cfloop list="#listRest(arguments.stringOfValues, '&')#" delimiters="&" index="thisParamSet">
		<cfset paramName = listFirst(thisParamSet, "=") />
		<cfset paramValue = listRest(thisParamSet, "=") />
		<cfset tempScope[paramName] = paramValue />
		<cfset arguments.eventContext.setValue(paramName, paramValue) />
	</cfloop>
	
	<cfif len( listFirst(arguments.stringOfValues, '&') ) GT 0>
      <cfset arguments.eventContext.forward(listFirst(arguments.stringOfValues, '&'), structKeyList(tempScope)) />
	</cfif>
	
	<cfreturn false />
</cffunction>

</cfcomponent>