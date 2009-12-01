<cfcomponent output="false" hint="I am a Model-Glue controller." extends="ModelGlue.gesture.controller.Controller">

	<cffunction name="init" access="public" output="false" hint="Constructor">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="validateForm" output="false">
		<cfargument name="event" />
		
		<cfset var validation = createObject("component", "ModelGlue.Util.ValidationErrorCollection").init() />
	
		<cfif not len(trim(arguments.event.getValue("name")))>
			<cfset validation.addError("name", "Please enter your name.") />
		</cfif>
		
		<cfif validation.hasErrors()>
			<cfset arguments.event.setValue("validationErrors", validation) />
			<cfset arguments.event.addResult("validationErrors") />
		<cfelse>
			<cfset arguments.event.addResult("success") />
		</cfif>
	</cffunction>
	
</cfcomponent>
	
