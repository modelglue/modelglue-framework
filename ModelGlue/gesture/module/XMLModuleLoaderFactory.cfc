<cfcomponent output="false" extends="ModelGlue.gesture.factory.TypeDefaultingMapBasedFactory" hint="I am a factory class that uses a configurable map to create instances various loaders of the XML Factory.">

<cffunction name="init" output="false">
	<cfargument name="modelGlueConfiguration" type="any" required="true">
	<cfargument name="registeredClasses" type="any" required="true" />
	<cfargument name="constructorArgs" type="struct" required="false" default="#structNew()#" hint="I am a collection that should be provided to an instantiated CFC's init() method.">
	<cfargument name="createSingletons" type="boolean" required="false" default="true" hint="Should instances be treated as singletons?" />
	<cfset variables._constructorArgs = arguments.constructorArgs  />
	<cfset variables._createSingletons = arguments.createSingletons />
	<cfset variables._modelGlueConfiguration = arguments.modelGlueConfiguration />
	<cfset super.init( registeredClasses:arguments.registeredClasses, constructorArgs:arguments.constructorArgs, createSingletons:arguments.createSingletons  ) />
	<cfreturn this />
</cffunction>

<cffunction name="create" output="false" hint="Creates and returns a desired implementation of an interface.">
	<cfargument name="name" type="string" required="true" hint="Name of type to create.  If not in registeredClasses (constructor arg), a CFC of the given type will be created." />
	<cfargument name="constructorArgs" type="struct" default="#structNew()#" required="false" hint="A struct of arguments to pass to the instance. This will override any defaults passed in the init function of TypeDefaultingMapBasedFactory">
	<cfreturn super.create( arguments.name, constructorArgs ) />
</cffunction>

	
</cfcomponent>
