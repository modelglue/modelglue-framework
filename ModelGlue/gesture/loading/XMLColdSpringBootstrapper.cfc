<cfcomponent output="false" extends="ModelGlue.gesture.loading.ColdSpringBootstrapper"
						 hint="I'm an extension of the ColdSpringBootstrapper that states an XML file to be loaded as a primary application module.">

<cfproperty name="initialModulePath" type="string" />

<cfset this.initialModulePath = "" />

</cfcomponent>