<cfcomponent output="false" extends="ModelGlue.gesture.controller.Controller">

<cffunction name="disableDebugging" output="false" hint="I instruct Model Glue innards to disable debug on a per request basis">
	<cfargument name="event" />
	<cfset request.modelGlueSuppressDebugging = "true" />  
</cffunction>

</cfcomponent>