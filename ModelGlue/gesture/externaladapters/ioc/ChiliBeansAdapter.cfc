<cfcomponent output="false" hint="Provides a common interface for ModelGlue to add bean definitions and request bean instances.  The implementation is targeted towards using ColdSpring.">

<cffunction name="init" output="false">
	<cfargument name="beanMappings" type="string" required="true" />
	
	<cfset variables._beanFactory = createObject("component", "ModelGlue.Bean.BeanFactory").init(arguments.beanMappings) />
	
	<cfreturn this />
</cffunction>

<cffunction name="loadBeanDefinitionsFromFile" output="false" hint="Adds additional bean mapping directory." access="public">
	<cfargument name="directory" type="string" hint="Directory containing bean definitions." />
	
	<cfset variables._beanFactory.addBeanMapping(arguments.directory) />
</cffunction>

<cffunction name="getBean" output="false" hint="Gets a bean by Id." access="public">
	<cfargument name="beanId" type="string" hint="Bean Id (ID attribute of the relevant <BEAN> tag)." />
	
	<cfreturn variables._beanFactory.createBean(arguments.beanId) />
</cffunction>

</cfcomponent>