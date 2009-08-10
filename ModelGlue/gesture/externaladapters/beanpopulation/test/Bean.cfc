<cfcomponent output="false">

<cfproperty name="explicitProp" />

<cfset this.explicitProp = "" />
<cfset this.initRan = false />

<cfset variables._implicitProp = "" />

<cffunction name="init">
	<cfset this.initRan = true />
	<cfreturn this />
</cffunction>

<cffunction name="getImplicitProp">
	<cfreturn variables._implicitProp />
</cffunction>

<cffunction name="setImplicitProp">
	<cfargument name="ImplicitProp" />
	<cfset variables._implicitProp = arguments.ImplicitProp />
</cffunction>

</cfcomponent>
