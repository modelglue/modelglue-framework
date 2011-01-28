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
