<cfcomponent output="false" hint="I am a factory class that uses a configurable map to create instances.  By passing ""create"" the name of a registered class, it will be created.  If the name isn't registered, a CFC of that name will be created.">

<cffunction name="init" output="false">
	<cfargument name="registeredClasses" type="struct" required="false" default="#structNew()#" hint="I am a structure of CFC names, keyed by an arbitrary id, that can be created.">
	<cfargument name="constructorArgs" type="struct" required="false" default="#structNew()#" hint="I am a collection that should be provided to an instantiated CFC's init() method.">
	<cfargument name="createSingletons" type="boolean" required="false" default="true" hint="Should instances be treated as singletons?" />
	<cfset variables._typeMap = arguments.registeredClasses />
	<cfset variables._constructorArgs = arguments.constructorArgs  />
	<cfset variables._singles = structNew() />
	<cfset variables._createSingletons = arguments.createSingletons />
	
	<cfreturn this />
</cffunction>

<cffunction name="create" output="false" hint="Creates and returns a desired implementation of an interface.">
	<cfargument name="name" type="string" required="true" hint="Name of type to create.  If not in registeredClasses (constructor arg), a CFC of the given type will be created." />
	<cfargument name="constructorArgs" type="struct" default="#structNew()#" required="false" hint="A struct of arguments to pass to the instance. This will override any defaults passed in the init function of TypeDefaultingMapBasedFactory">
	<cfset var inst = 0 />
	<cfset var constArgs = variables._constructorArgs />
	<cfset structAppend( constArgs, arguments.constructorArgs ) />
	<cfif not variables._createSingletons>
	
		<!--- Create and cache --->
		<cfif structKeyExists(variables._typeMap, arguments.name)>
			<cfset inst = createObject("component", variables._typeMap[arguments.name].class) />
		<cfelse>
			<cfset inst = createObject("component", arguments.name) />
		</cfif>

		<!--- Call constructor --->
		<cfif structKeyExists(inst, "init")>
			<cfinvoke component="#inst#" argumentCollection="#constArgs#" method="init" />
		</cfif>
		
		<cfreturn inst />
	<cfelseif structKeyExists(variables._singles, arguments.name)>
		<cfreturn variables._singles[arguments.name] />
	<cfelse>
		<!--- Double-checked lock prevents two instances from being created. --->
		<cflock name="TypeDefaultingMapBasedFactory.#name#.singletonInstantiaion" type="exclusive" timeout="600">
			<cfif structKeyExists(variables._singles, arguments.name)>
				<cfreturn variables._singles[arguments.name] />
			<cfelse>

				<!--- Create and cache --->
				<cfif structKeyExists(variables._typeMap, arguments.name)>
					<cfset variables._singles[arguments.name] = createObject("component", variables._typeMap[arguments.name].class) />
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
	