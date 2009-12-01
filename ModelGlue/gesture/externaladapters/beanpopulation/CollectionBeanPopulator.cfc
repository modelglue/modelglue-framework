<cfcomponent output="false"
						 hint="I am an Adapter implementation providing a wrapper around a CollectionBeanMaker instance.">
						 
<cffunction name="init" output="false">
	<cfargument name="beanMaker" required="true" default="#createObject("component", "ModelGlue.Util.CollectionBeanMaker").init()#" hint="CollectionBeanMaker instance to wrap." />
	
	<cfset variables._bu = arguments.beanMaker />
	
	<cfreturn this />
</cffunction>

<cffunction name="populate" output="false">
	<cfargument name="target" type="any" hint="Either an instance of a CFC or the name of a CFC (e.g., ""com.mydomain.mymodel.MyBean"") to populate." />
	<cfargument name="source" type="any" hint="A collection to use as source for population." />
	<cfargument name="properties" type="string" hint="List to populate." />
	
	<!--- Create instance if simple target --->
	<cfif not isStruct(arguments.target)>
		<cfset arguments.target = createObject("component", arguments.target) />
		<cfif structKeyExists(arguments.target, "init")>
			<cfinvoke component="#arguments.target#" method="init" />
		</cfif>
	</cfif>
	<!--- Populate --->
	<cfif structKeyExists(arguments, "properties") AND len(trim( arguments.properties ) )>
		<cfset variables._bu.makeBean(arguments.source, arguments.target, arguments.properties) />
	<cfelse>
		<cfset variables._bu.makeBean(arguments.source, arguments.target) />
	</cfif>
	
	<cfreturn arguments.target />
</cffunction>

</cfcomponent>