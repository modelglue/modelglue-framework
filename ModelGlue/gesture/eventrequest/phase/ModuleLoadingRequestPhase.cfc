<cfcomponent output="false" extends="ModelGlue.gesture.eventrequest.EventRequestPhase"
						 hint="Abstract of an execution phase that loads modules."
>
	
<cffunction name="init" output="false">
	<cfargument name="moduleLoaderFactory" require="true" hint="I am the factory through which module loaders may be attained." />
	<cfargument name="modules" type="array" required="true" hint="I am the list of XML modules to load as part of this phase." />
	
	<cfset variables._moduleLoader = arguments.moduleLoaderFactory.create("XML") />
	<cfset variables._modules = arguments.modules />	
</cffunction>

<cffunction name="load" access="private" returntype="void" output="false" hint="I perform the loading for this phase.">
	<cfargument name="eventContext" hint="I am the event context to use for loading.  Duck typed for speed.  Should have no queued events, but this isn't checked (to save time)." />
	
	<cfset loadModules(arguments.eventContext.getModelGlue()) />
</cffunction>

<cffunction name="loadModules" access="private" output="false" hint="Loads modules associated with this phase.">
	<cfargument name="modelglue" />
	
	<cfset var i = "" />
	
	<cfloop from="1" to="#arrayLen(variables._modules)#" index="i">
		<cfset variables._moduleLoader.load(modelglue, variables._modules[i]) />
	</cfloop>
</cffunction>

</cfcomponent>