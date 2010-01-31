<cfcomponent output="false" hint="I am a Model-Glue controller." extends="ModelGlue.gesture.controller.Controller">

	<cffunction name="init" access="public" output="false" hint="Constructor">
		<cfargument name="framework" />
		
		<cfset super.init(framework) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="onRequestStart" access="public" output="false" returntype="void" hint="I add a test value to the event">
		<cfargument name="event" type="any" required="true" />
		
		<cfset arguments.event.setValue("onRequestStartTest", "onRequestStartTest") />
	</cffunction>
	
</cfcomponent>