<cfcomponent output="false" hint="I am a Model-Glue controller.  I contain ""listener functions"" that are executed in response to messages broadcast by EventHandlers, subscribed by addEventListener().">

<cffunction name="init" output="false" hint="Constructor.">
	<cfargument name="modelglue" required="false" hint="Instance of ModelGlue itself.  Not necessary for construction, and primarily included for reverse compatibility." />
	
	<cfif structKeyExists(arguments, "modelglue")>
		<cfset setModelGlue(arguments.modelglue) />
	</cfif>
	
	<cfreturn this />
</cffunction>

<cffunction name="setModelGlue" output="false" hint="I set the core ModelGlue instance this controller is concerned with.">
	<cfargument name="modelGlue" hint="The instance of Model-Glue in question." />
	<cfset variables._modelGlue = arguments.modelGlue />
</cffunction>
<cffunction name="getModelGlue" output="false" hint="I get the core ModelGlue instance this controller is concerned with.">
	<cfreturn variables._modelGlue />
</cffunction>

</cfcomponent>