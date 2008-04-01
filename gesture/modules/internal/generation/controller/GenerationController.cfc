<cfcomponent output="false" extends="ModelGlue.gesture.controller.Controller" beans="modelglue.sessionFacade">

<cffunction name="generateEvent" output="false" hint="If the requested event doesn't exist, I generate its XML as well as code stubs for a listener and a view.">
	<cfargument name="event" />
	
	<cfset var eventName = arguments.event.getValue(arguments.event.getValue("eventValue")) />
	
	<cflog text="GEN THIS: #eventName#" />
</cffunction>

</cfcomponent>