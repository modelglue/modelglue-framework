<cfcomponent output="false" extends="ModelGlue.gesture.eventrequest.EventRequestPhase"
						 hint="Represents the beginning of the Model-Glue lifecycle.  Execution only does work when Model-Glue is not initialized."
>
	
<cffunction name="init" output="false">
	<cfargument name="moduleLoaderFactory" require="true" hint="I am the factory through which module loaders may be attained." />
	<cfargument name="modules" type="array" required="true" hint="I am the list of XML modules to load as part of this phase." />
	
	<cfset variables._moduleLoader = arguments.moduleLoaderFactory.create("XML") />
	<cfset variables._modules = arguments.modules />	
</cffunction>

<cffunction name="execute" returntype="void" output="false" hint="Executes the request phase.">
	<cfargument name="eventContext" hint="I am the event context to act upon.  Duck typed for speed.  Should have no queued events when execute() is called, but this isn't checked (to save time)." />
	
	<cfset var modelglue = arguments.eventContext.getModelGlue() />
	<cfset var event = "" />
	
	<!--- 
		Before event queue runs, we need to load any configured modules.
	--->
	
	<cfset loadModules(modelglue) />
	
	<!--- Add the newly loaded event to the queue. --->
	<cfset event =  modelglue.getEventHandler("modelglue.onApplicationInitialization") />
	<cfset arguments.eventContext.addEventHandler(event) />
	
	<!--- Tell the context to run its queue. --->
	<cfset arguments.eventContext.executeEventQueue() />

	<cfset event =  modelglue.getEventHandler("modelglue.onApplicationStoredInScope") />
	<cfset arguments.eventContext.addEventHandler(event) />
</cffunction>

<cffunction name="loadModules" access="private" output="false" hint="Loads modules associated with this phase.">
	<cfargument name="modelglue" />
	
	<cfset var i = "" />
	
	<cfloop from="1" to="#arrayLen(variables._modules)#" index="i">
		<cfset variables._moduleLoader.load(modelglue, variables._modules[i]) />
	</cfloop>
</cffunction>

</cfcomponent>