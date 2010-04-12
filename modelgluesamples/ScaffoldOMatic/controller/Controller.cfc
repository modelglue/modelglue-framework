<cfcomponent output="false" hint="I am a Model-Glue controller." 
	extends="ModelGlue.gesture.controller.Controller"
	beans="CFUniFormConfigBean">

	<cffunction name="onRequestStart" output="false" access="public" returntype="void" hint="">
		<cfargument name="event">
		<cfset arguments.event.setValue("UserMsg", createobject("component", "ScaffoldOMatic.model.UserMessageContainer").init()  ) />
		<cfset arguments.event.setValue("CFUniFormConfig", duplicate(beans.CFUniFormConfigBean) ) />
		<cfset arguments.event.setValue("CurrentPage", createobject("component", "ScaffoldOMatic.model.CurrentPage").init(eventName:event.getValue(event.getValue("eventValue" ) ) ) ) />
	</cffunction>

	
</cfcomponent>
	
