<cfcomponent displayname="ValidationService" output="false" hint="I am the default validation service.">

<cffunction name="init" access="public" returntype="any" output="false">
	<cfreturn this />
</cffunction>

<cffunction name="validate" access="public" returntype="any" output="false" hint="I attempt to validate an object, returning a ValidationErrorCollection">
	<cfargument name="table" type="any" required="true" hint="The name of the type of object" />
	<cfargument name="record" type="any" required="true" hint="The actual business object" />

	<cfreturn variables.Framework.getOrmAdapter().validate(arguments.table, arguments.record) />
</cffunction>

<cffunction name="getFramework" access="public" output="false" returntype="any">
	<cfreturn variables.Framework />
</cffunction>

<cffunction name="setFramework" access="public" output="false" returntype="void">
	<cfargument name="Framework" type="any" required="true" />
	<cfset variables.Framework = arguments.Framework />
</cffunction>



</cfcomponent>