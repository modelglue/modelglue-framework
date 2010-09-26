<cfcomponent beans="bean,bean2">

<cfset setVariablesValue("internallySet") />

<cffunction name="setBean">
	<cfargument name="bean" />
	<cfset variables._bean = arguments.bean />
</cffunction>

<cffunction name="setBean2">
	<cfargument name="bean2" />
	<cfset variables._bean2 = arguments.bean2 />
</cffunction>

<cffunction name="setVariablesValue">
	<cfargument name="value" />
	
	<cfset variables._value = arguments.value />
</cffunction>

<cffunction name="getVariablesValue">
	<cfreturn variables._value />
</cffunction>

</cfcomponent>