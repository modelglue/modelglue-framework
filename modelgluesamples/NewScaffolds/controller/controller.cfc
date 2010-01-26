<cfcomponent output="false" hint="I am a Model-Glue controller." extends="ModelGlue.gesture.controller.Controller" 
			beans="CFUniFormConfigBean">

	<cffunction name="onRequestStart" output="false" access="public" returntype="void" hint="">
		<cfargument name="event">
		<cfset event.setValue("CFUniformConfig", duplicate( beans.CFUniFormConfigBean ) )>
	</cffunction>

</cfcomponent>