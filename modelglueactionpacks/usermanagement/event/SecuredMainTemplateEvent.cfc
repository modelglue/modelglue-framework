<cfcomponent extends="modelglueactionpacks.common.event.MainTemplateEvent">

<cffunction name="beforeConfiguration" access="public" returntype="void" output="false" hint="Called after configuring the event handler.  Subclasses can use this to add messages, results, or views after they're added by something like a ModelGlue XML file.">
	<cfset var message = createObject("component", "ModelGlue.gesture.eventhandler.Message") />

	<cfset super.beforeConfiguration() />
	
	<cfset message.name = "userManagement.checkSecuredEvent" />

	<cfset addMessage(message) />
</cffunction>

<cffunction name="afterConfiguration" access="public" returntype="void" output="false" hint="Called after configuring the event handler.  Subclasses can use this to add messages, results, or views after they're added by something like a ModelGlue XML file.">
	<cfset var result = createObject("component", "ModelGlue.gesture.eventhandler.Result") />
	
	<cfset super.afterConfiguration() />

	<cfset result.name = "securedEvent.userNotInPermittedGroup" />
	<cfset result.event = "userManagement.logout" />

	<cfset addResult(result) />
</cffunction>

</cfcomponent>