<cfcomponent output="false" extends="ModelGlue.gesture.loading.RequestScopeBootstrapper"
						 hint="I contain information needed to load Model-Glue into the applciation scope based on a ColdSpring bean factory.">

<cfproperty name="coldspringPath" type="string" hint="The logical path (mapping-based) to the ColdSpring .xml file containing bean definitions for the Model-Glue application." />
<cfproperty name="parentBeanFactory" type="any" hint="A parent bean factory to join to." />
<cfproperty name="modelGlueBeanName" type="string" default="modelglue.ModelGlue" hint="The name of the bean that is the instance of ModelGlue.cfc to use as the framework." />
<cfproperty name="modelGlueConfigurationBeanName" type="string" default="modelglue.ModelGlueConfiguration" hint="The name of the bean that is the instance of ModelGlueConfiguration.cfc to use as the framework's configuration." />

<cfset this.coldspringPath = "" />
<cfset this.parentBeanFactory = "" />
<cfset this.modelGlueBeanName = "modelglue.ModelGlue" />
<cfset this.modelGlueConfigurationBeanName = "modelglue.ModelGlueConfiguration" />

<cffunction name="createBeanFactory" output="false" hint="Configures and returns the bean factory for use.">
	<cfset var bf = createObject("component", "coldspring.beans.DefaultXmlBeanFactory").init() />
	
	<cfset bf.loadBeans(expandPath(this.coldspringPath)) />
	
	<cfif isObject(this.parentBeanFactory)>
		<cfset bf.setParent(this.parentBeanFactory) />
	</cfif>
	
	<cfreturn bf />
</cffunction>

<cffunction name="createModelGlue" output="false" hint="Creates and sets configuration into an instance of ModelGlue.cfc (created from ColdSpring definition.">
	<cfset var bf = createBeanFactory() />
	<cfset var mg = bf.getBean(this.modelGlueBeanName) />

	<cfset mg.setInternalBeanFactory(bf) />	
	
	<cfreturn mg />
</cffunction>

<cffunction name="storeModelGlue" output="false" hint="Creates and sets configuration into an instance of ModelGlue.cfc (created from ColdSpring definition.">
	<cfset super.storeModelGlue(createModelGlue()) />
</cffunction>

</cfcomponent>