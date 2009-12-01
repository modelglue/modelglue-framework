<cfcomponent output="false" hint="I am a Model-Glue controller." extends="ModelGlue.gesture.controller.Controller">

	<cffunction name="onApplicationStart" output="false">
		<cfargument name="event" />

		<cfset variables.sessionCount = 0 />
	</cffunction>
	
	<cffunction name="getSessionCount" output="false">
		<cfargument name="event" />
		
		<cfset arguments.event.setValue("sessionCount", variables.sessionCount) />
	</cffunction>

	<cffunction name="incrementSessionCount" output="false">
		<cfargument name="event" />
		
		<cfset variables.sessionCount = variables.sessionCount + 1 />
	</cffunction>

	<cffunction name="decrementSessionCount" output="false">
		<cfargument name="event" />
		
		<cfset variables.sessionCount = variables.sessionCount - 1 />
	</cffunction>
	
	
</cfcomponent>
	
