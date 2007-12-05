<cfcomponent output="false" hint="I am a Model-Glue controller.  I contain ""listener functions"" that are executed in response to messages broadcast by EventHandlers, subscribed by addEventListener().">

<cffunction name="init" output="false" hint="Constructor.">
	<cfreturn this />
</cffunction>

<cffunction name="setModelGlue" output="false" hint="I set the core ModelGlue instance this controller is concerned with.">
	<cfargument name="modelGlue" hint="The instance of Model-Glue in question." />
</cffunction>

</cfcomponent>