<cfcomponent output="false" extends="ModelGlue.gesture.controller.Controller">

<cffunction name="populateEventContext" output="false" hint="I get the list of populators and populate the event context.">
	<cfargument name="event" />
	
	<cfset var pops = arguments.event.getModelGlue().populators />
	<cfset var i = "" />
	
	<cfloop from="1" to="#arrayLen(pops)#" index="i">
		<cfset pops[i].populate(arguments.event) />
	</cfloop>
</cffunction>

</cfcomponent>