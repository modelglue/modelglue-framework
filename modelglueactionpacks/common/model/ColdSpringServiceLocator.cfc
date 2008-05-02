<cfcomponent output="false" hint="I am a service locator that adapts to ColdSpring's API.">

<cffunction name="setBeanFactory" returntype="void" access="public">
	<cfargument name="factory" type="coldspring.beans.BeanFactory" required="true">
	<cfset variables._bf = arguments.factory />
</cffunction> 

<cffunction name="getService" output="false">
	<cfargument name="name" />
	<cfreturn variables._bf.getBean(arguments.name) />
</cffunction>

</cfcomponent>