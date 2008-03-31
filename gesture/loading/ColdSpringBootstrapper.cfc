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
	<cfset var csPath = this.coldspringPath />
	<cfset var originalCsPath = csPath />
	<cfset var cfg = "" />

	<!--- If we're in legacy or unity mode, we must explicitly load use the internal configuration file --->
	<cfif this.modelglueVersionIndicator eq this.versionIndicators.legacy
				or this.modelglueVersionIndicator eq this.versionIndicators.unity>
		<cfset csPath = expandPath("/ModelGlue/gesture/configuration/ModelGlueConfiguration.xml") />
	</cfif>
	
	<cfif not fileExists(csPath)>
		<cfset csPath = expandPath(csPath) />
	</cfif>

	<cfif not fileExists(csPath)>
		<cfthrow message="Can't create beanfactory:  The ColdSpring path indicated (#csPath#) doesn't exist!" />
	</cfif>
	
	<cfset bf.loadBeans(csPath) />

	<!--- If we're in unity mode, we now load the _local_ ColdSpring beans on top of the core 
				and handle compatability bean id's.
	--->
	<cfif this.modelglueVersionIndicator eq this.versionIndicators.unity>
		<cfif not fileExists(originalCsPath)>
			<cfset originalCsPath = expandPath(originalCsPath) />
		</cfif>
	
		<cfif not fileExists(originalCsPath)>
			<cfthrow message="Can't create beanfactory:  The ColdSpring path indicated (#originalCsPath#) doesn't exist!" />
		</cfif>

		<cfset bf.loadBeans(originalCsPath) />
		
		<!--- TODO: Compatibility aliases
		<cfset bf.loadBeans(expandPath("/ModelGlue/unity/config/UnityCompatabilityAliases.xml")) />
		 --->
	</cfif>

	<!--- If we're in legacy mode, we change the value of the primaryModule in the configuration. --->
	<cfif this.modelglueVersionIndicator eq this.versionIndicators.legacy>
		<cfset cfg = bf.getBean("modelglue.ModelGlueConfiguration") />
		<cfset cfg.setPrimaryModule(this.primaryModulePath) />
	</cfif>
		
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
	<cfreturn super.storeModelGlue(createModelGlue()) />
</cffunction>

</cfcomponent>