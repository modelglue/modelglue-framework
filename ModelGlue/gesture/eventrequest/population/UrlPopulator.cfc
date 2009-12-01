<cfcomponent output="false" extends="ModelGlue.gesture.eventrequest.population.StructBasedPopulator"
					   hint="I populate an event context from the url scope.  The values are determined by the assigned UrlManager instance."
>

<cffunction name="setUrlManager" output="false" hint="I set the URL manager to use.">
	<cfargument name="urlManager" />
	<cfset variables._urlManager = arguments.urlManager />
</cffunction>

<cffunction name="populate" output="false" hint="I receive a structure and an event context and populate the event context from the structure.">
	<cfargument name="context" hint="EventContext to populate." />
	
	<cfset super.populate(context, variables._urlManager.extractValues()) />
	
	<cfset variables._urlManager.populateLocation(arguments.context) />
</cffunction>

</cfcomponent>