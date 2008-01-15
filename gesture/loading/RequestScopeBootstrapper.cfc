<cfcomponent output="false" hint="I'm a bootstrapper that loads an instance of ModelGlue.cfc into a named position in the Request scope.">

<cfproperty name="applicationKey" type="string" hint="The name of the variable in application scope in which Model-Glue should eventually be stored." />
<cfproperty name="modelglueVersionIndicator" type="string" hint="Indicator of which version of Model-Glue is loading.  Set to a value in this.versionIndicators." />
<cfproperty name="primaryModulePath" type="string" hint="In order to support legacy applications, we allow primary application module to be defined in the bootstrapper rather than in a proper configuation." />

<cfset this.applicationKey = "modelglue" />
<cfset this.primaryModulePath = "" />
<cfset this.versionIndicators = structNew() />
<cfset this.versionIndicators.legacy = "LEGACY" />
<cfset this.versionIndicators.unity = "UNITY" />
<cfset this.versionIndicators.gesture = "GESTURE" />

<cfset this.modelglueVersionIndicator = this.versionIndicators.gesture />

<cffunction name="storeModelGlue" output="false" hint="Stores the framework and the bootstrapper in request._modelGlue.bootstrapper.">
	<cfargument name="framework" />

	<cfset request._modelGlue.bootstrap.framework = arguments.framework />
	<cfset request._modelGlue.bootstrap.bootstrapper = this />
	
	<cfreturn arguments.framework />
</cffunction>

</cfcomponent>