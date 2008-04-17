<cfcomponent output="false"
						 hint="I am an Adapter implementation providing a wrapper around a BeanUtils instance.">
						 
<cffunction name="init" output="false">
	<cfargument name="beanUtils" required="true" default="#createObject("component", "com.firemoss.beanutils.BeanUtils").init()#" hint="BeanUtils instance to wrap." />
	
	<cfset variables._bu = arguments.beanUtils />
	
	<cfreturn this />
</cffunction>

<cffunction name="populate" output="false">
	<cfargument name="target" type="any" hint="Either an instance of a CFC or the name of a CFC (e.g., ""com.mydomain.mymodel.MyBean"") to populate." />
	<cfargument name="source" type="any" hint="A structure to use as source for population." />
	
	<!--- Create instance if simple target --->
	<cfif not isObject(arguments.target)>
		<cfset arguments.target = createObject("component", arguments.target) />
		<cfif structKeyExists(arguments.target, "init")>
			<cfinvoke component="#arguments.target#" method="init" />
		</cfif>
	</cfif>
	
	<!--- Populate --->
	<cfset variables._bu.inject(arguments.source, arguments.target) />
	
	<cfreturn arguments.target />
</cffunction>

</cfcomponent>