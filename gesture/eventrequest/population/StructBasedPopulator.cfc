<cfcomponent output="false" hint="I populate an event context from a structure.">

<cffunction name="init" output="false">
	<cfreturn this />
</cffunction>

<cffunction name="populate" output="false" hint="I receive a structure and an event context and populate the event context from the structure.">
	<cfargument name="context" hint="EventContext to populate." />
	<cfargument name="source" type="struct" hint="Source data for population." />
	
	<cfset var i = "" />
	
	<cfloop collection="#arguments.source#" item="i">
		<cfset arguments.context.setValue(i, arguments.source[i]) />
	</cfloop> 
</cffunction>

</cfcomponent>