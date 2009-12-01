<cfcomponent output="false" hint="Provides a common interface for ModelGlue to add bean definitions and request bean instances.  The implementation is targeted towards using ColdSpring.">

<cffunction name="init" output="false">
	<cfreturn this />
</cffunction>

<cffunction name="setBeanFactory" output="false" hint="Bean-factory-aware implementation" access="public">
	<cfargument name="beanFactory" type="coldspring.beans.BeanFactory" />
	
	<cfset variables._beanFactory = arguments.beanFactory />
</cffunction>

<cffunction name="loadBeanDefinitionsFromFile" output="false" hint="Adds additional bean definitions from a file." access="public">
	<cfargument name="filename" type="string" hint="Filename containing bean definitions." />
	
	<cfset variables._beanFactory.loadBeans(expandPath(arguments.filename)) />
</cffunction>

<cffunction name="getBean" output="false" hint="Gets a bean by Id." access="public">
	<cfargument name="beanId" type="string" hint="Bean Id (ID attribute of the relevant <BEAN> tag)." />
	
	<cfreturn variables._beanFactory.getBean(arguments.beanId) />
</cffunction>

<cffunction name="beanDefinitionExists" access="public" returntype="boolean" output="false"
			hint="searches all known factories (parents) to see if bean definition for the specified bean exists">
	<cfargument name="beanName" type="string" required="true" />
	<cfreturn variables._beanFactory.beanDefinitionExists( arguments.beanName ) />
</cffunction>
</cfcomponent>