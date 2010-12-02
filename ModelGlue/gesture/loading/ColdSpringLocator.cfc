<cfcomponent output="false" hint="I can be used to get the Coldspring bean factory out of Model-Glue.">

	<cfproperty name="ModelGlue_APP_KEY" type="any" hint="The Coldspring bean factory." />

	<cffunction name="init" output="false" returntype="any" hint="Creates an instance of the ColdspringLocator.">
		<cfargument name="ModelGlue_APP_KEY" required="true" hint="The key in the Application scope in which Model-Glue is stored." />
	
		<cfset variables.ModelGlue_APP_KEY = arguments.ModelGlue_APP_KEY />
		
		<cfreturn this />
	
	</cffunction>
	
	<cffunction name="getBeanFactory" output="false" returntype="any" hint="Returns the Coldspring bean factory.">
	
		<cfreturn application[variables.ModelGlue_APP_KEY].getInternalBeanFactory() />
	
	</cffunction>
	
	<cffunction name="getBean" output="false" returntype="any" hint="Returns a bean from the Coldspring bean factory.">
		<cfargument name="beanId" required="true" hint="The Id of the bean in Coldspring." />
	
		<cfreturn application[variables.ModelGlue_APP_KEY].getBean(arguments.beanId) />
	
	</cffunction>
	
</cfcomponent>
