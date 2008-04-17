<cfcomponent output="false" hint="Saves and loads event context state from session._modelGluePreservedState.">

<cffunction name="save" output="false" hint="Saves state.  Fails silently if anything goes wrong.">
	<cfargument name="eventContext" output="false" hint="Event context from which state should be saved." />

	<cftry>
		<cfset session._modelgluePreservedState = arguments.eventContext.getAll() />
		<cfcatch></cfcatch>
	</cftry>
</cffunction>

<cffunction name="load" output="false" hint="Loads state.  Fails silently if anything goes wrong.">
	<cfargument name="eventContext" output="false" hint="Event context into which state should be loaded" />

	<cftry>
		<cfif structKeyExists(session, "_modelgluePreservedState")>
			<cfset arguments.eventContext.merge(session._modelgluePreservedState) />
			<cfset structDelete(session, "_modelgluePreservedState") />
		</cfif>
		<cfcatch></cfcatch>
	</cftry>
</cffunction>

</cfcomponent>