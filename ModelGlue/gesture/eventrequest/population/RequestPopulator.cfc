<cfcomponent output="false" extends="ModelGlue.gesture.eventrequest.population.StructBasedPopulator"
					   hint="I populate an event context from the request scope.  The scope is hard-coded:  this is low-level framework bits, and the overhead of a dynamic facade is a hit we don't want to take."
>


<cffunction name="populate" output="false" hint="I receive a structure and an event context and populate the event context from the structure.">
	<cfargument name="context" hint="EventContext to populate." />
	
	<cfset super.populate(context, request._modelglue) />
</cffunction>

</cfcomponent>