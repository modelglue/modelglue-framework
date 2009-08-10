<cfcomponent output="false" hint="I am a Model-Glue controller." extends="ModelGlue.gesture.controller.Controller"
						 beans="translator"
>

	<cffunction name="init" access="public" output="false" hint="Constructor">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="translate" access="public" output="false">
		<cfargument name="event" />
		
		<cfset var phrase = event.getValue("phrase") />
		<cfset var translated = beans.translator.translate(phrase) />
		
		<cfset event.setValue("translated", translated) />
	</cffunction>
</cfcomponent>
	
