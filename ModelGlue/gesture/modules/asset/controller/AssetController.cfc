<cfcomponent output="false" extends="ModelGlue.gesture.controller.Controller">

	<cffunction name="renderAssets" access="public" output="false" returntype="void">
		<cfargument name="event" type="any" required="true" />
		
		<cfset arguments.event.renderAssets() />
	</cffunction>

</cfcomponent>