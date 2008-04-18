<cfcomponent output="false" hint="Saves and loads event context state from session._modelGluePreservedState.">

<cffunction name="init" output="false">
	<cfargument name="sessionFacade" />
	<cfset variables.sessionFacade = arguments.sessionFacade />

	<cfreturn this />
</cffunction>

<cffunction name="save" output="false" hint="Saves state.  Fails silently if anything goes wrong.">
	<cfargument name="eventContext" output="false" hint="Event context from which state should be saved." />

	<cfset variables.sessionFacade.put("_modelgluePreservedState", arguments.eventContext.getAll()) />
</cffunction>

<cffunction name="load" output="false" hint="Loads state.  Fails silently if anything goes wrong.">
	<cfargument name="eventContext" output="false" hint="Event context into which state should be loaded" />

	<cfif variables.sessionFacade.exists("_modelgluePreservedState")>
		<cfset arguments.eventContext.merge(variables.sessionFacade.get("_modelgluePreservedState")) />
		<cfset variables.sessionFacade.delete("_modelgluePreservedState") />
	</cfif>
</cffunction>

</cfcomponent>