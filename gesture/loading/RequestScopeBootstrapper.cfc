<cfcomponent output="false" hint="I'm a bootstrapper that loads an instance of ModelGlue.cfc into a named position in the Request scope.">

<cfproperty name="applicationKey" type="string" hint="The name of the variable in application scope in which Model-Glue should eventually be stored." />

<cfset this.applicationKey = "modelglue" />

<cffunction name="storeModelGlue" output="false" hint="Stores the framework and the bootstrapper in request._modelGlue.bootstrapper.">
	<cfargument name="framework" />
	<cfset request._modelGlue.bootstrapper = structNew() />
	<cfset request._modelGlue.bootstrapper.framework = arguments.framework />
	<cfset request._modelGlue.bootstrapper.bootstrapper = this />
</cffunction>

</cfcomponent>