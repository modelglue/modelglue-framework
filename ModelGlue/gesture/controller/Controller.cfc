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

<cffunction name="setHelpers" output="false" hint="Sets the ""helpers"" scope into this controller.">
	<cfargument name="helpers" />
	<cfset variables.helpers = arguments.helpers />
</cffunction>

<!--- Legacy methods for caching values. Methods use the cache adapter injected into the "beans" scope. --->

<cffunction name="AddToCache" access="public" returnType="void" output="false" hint="I add a value to the cache.">
    <cfargument name="name" type="string" required="true" hint="I am the name of the value." />
    <cfargument name="value" type="any" required="true" hint="I am the value." />
    <cfargument name="timeout" type="numeric" required="false" hint="I am the [optional] timespan for which this value should be cached." />

	<cfif structKeyExists(arguments, "timeout")>
		<cfset beans.CacheAdapter.put("value." & arguments.name, arguments.value, arguments.timeout) />
	<cfelse>
		<cfset beans.CacheAdapter.put("value." & arguments.name, arguments.value) />
	</cfif>
</cffunction>

<cffunction name="ExistsInCache" access="public" returnType="boolean" output="false" hint="I check whether a value exists in the cache.">
    <cfargument name="name" type="string" required="true" hint="I am the name of the value.">
    <cfset var cacheReq = beans.CacheAdapter.get("value." & arguments.name) />

	<cfreturn cacheReq.success />
</cffunction>

<cffunction name="GetFromCache" access="public" returnType="any" output="false" hint="I return a value if it cached, or thow an exception if it is not.">
    <cfargument name="name" type="string" required="true" hint="I am the name of the value.">
    <cfset var cacheReq = beans.CacheAdapter.get("value." & arguments.name) />

    <cfif cacheReq.success>
		<cfreturn cacheReq.content />
	<cfelse>
		<!--- Exception type matches one used in Unity for compatibility --->
		<cfthrow type="ModelGlue.Util.TimedCache.ItemNotFound" message="Request value '#arguments.name#' not in cache." />
	</cfif>
</cffunction>

<cffunction name="RemoveFromCache" access="public" returnType="boolean" output="false" hint="I remove a value from the cache.">
    <cfargument name="name" type="string" required="true" hint="I am the name of the value.">

	<cfreturn beans.CacheAdapter.purge("value." & arguments.name) />
</cffunction>

</cfcomponent>