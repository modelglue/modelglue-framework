<cfcomponent output="false" hint="Replaces createObject() for creating transient CFC instances and wiring in a getService() function.">

<cffunction name="init" output="false">
	<cfargument name="serviceLocator" />
	<cfset variables.serviceLocator = arguments.serviceLocator />
</cffunction>

<cffunction name="new" output="false">
	<cfargument name="cfcname" />
	<cfargument name="constructorArgs" default="#structNew()#" />
	
	<cfset var instance = createObject("component", arguments.cfcname) />
	<cfset var variablesScope = "" />
	
	<cfset instance._objectFactory_injectServiceLocator = this.injectServiceLocator />
	<cfset instance._objectFactory_getVariablesScope = this.getVariablesScope />
	
	<cfset variablesScope = instance._objectFactory_getVariablesScope() />
	
	<cfset variablesScope.getService = this.getService />
	
	<cfset instance._objectFactory_injectServiceLocator(variables.serviceLocator) />
	
	<cfset instance.init(argumentCollection=arguments.constructorArgs) />
	
	<cfreturn instance />
</cffunction>

<cffunction name="injectServiceLocator" output="false">
	<cfargument name="serviceLocator" />
	<cfset variables.serviceLocator = arguments.serviceLocator />
</cffunction>

<cffunction name="getService" output="false">
	<cfargument name="name" />
	<cfreturn variables.serviceLocator.getService(arguments.name) />
</cffunction>

<cffunction name="getVariablesScope" hint="Method template to get a target's variables scope.">
	<cfreturn variables />
</cffunction>

</cfcomponent>