<!---
LICENSE INFORMATION:

Copyright 2011, Joe Rinehart, Dan Wilson

Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. 

You may obtain a copy of the License at 

	http://www.apache.org/licenses/LICENSE-2.0 
	
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.

VERSION INFORMATION:

This file is part of @versionLabel@ (@versionNumber@).

The version number in parentheses is in the format versionNumber.subversion.revisionNumber.

If the version number appears as 'versionNumber' surrounded by @ symbols
then this file is a working copy and not part of a release build.
--->


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
