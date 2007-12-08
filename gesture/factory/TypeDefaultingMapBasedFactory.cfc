<cfcomponent output="false" hint="I am a factory class that uses a configurable map to create singleton instances.  By passing ""create"" the name of a registered class, it will be created.  If the name isn't registered, a CFC of that name will be created.">

<cffunction name="init" output="false">
	<cfargument name="registeredClasses" type="struct" required="false" default="#structNew()#" hint="I am a structure of CFC names, keyed by an arbitrary id, that can be created.">
	<cfargument name="constructorArgs" type="struct" required="false" default="#structNew()#" hint="I am a collection that should be provided to an instantiated CFC's init() method.">
	
	<cfset variables._typeMap = arguments.registeredClasses />
	<cfset variables._constructorArgs = arguments.constructorArgs  />
	<cfset variables._singles = structNew() />
	
	<cfreturn this />
</cffunction>

<cffunction name="create" output="false" hint="Creates and returns a desired implementation of an interface.">
	<cfargument name="name" type="string" required="true" hint="Name of type to create.  If not in registeredClasses (constructor arg), a CFC of the given type will be created." />

	<!--- Double-checked lock prevents two instances from being created. --->
	<cfif structKeyExists(variables._singles, arguments.name)>
		<cfreturn variables._singles[arguments.name] />
	<cfelse>

		<cflock name="TypeDefaultingMapBasedFactory.#name#.singletonInstantiaion" type="exclusive" timeout="600">
			<cfif structKeyExists(variables._singles, arguments.name)>
				<cfreturn variables._singles[arguments.name] />
			<cfelse>

				<!--- Create and cache --->
				<cfif structKeyExists(variables._typeMap, arguments.name)>
					<cfset variables._singles[arguments.name] = createObject("component", variables._typeMap[arguments.name]) />
				<cfelse>
					<cfset variables._singles[arguments.name] = createObject("component", arguments.name) />
				</cfif>

				<!--- Call constructor --->
				<cfif structKeyExists(variables._singles[arguments.name], "init")>
					<cfinvoke component="#variables._singles[arguments.name]#" argumentCollection="#variables._constructorArgs#" method="init" />
				</cfif>
				
				<cfreturn variables._singles[arguments.name] />
			</cfif>			
		</cflock>

	</cfif>
</cffunction>

</cfcomponent>		
	