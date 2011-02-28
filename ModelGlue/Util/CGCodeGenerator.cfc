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


<cfcomponent output="false" hint="A lo-fi ColdFusion code generator that uses content with ""<cg"" tags and ""<=--"" comments instead of XML or templating.">

<cffunction name="init" output="false">
</cffunction>

<cffunction name="clean" output="false">
	<cfargument name="content" />
	
	<cfset arguments.content = replaceNoCase(content, "<cg", "<cf", "all") />
	<cfset arguments.content = replaceNoCase(content, "</cg", "</cf", "all") />
	<cfset arguments.content = replaceNoCase(content, "<=--", "<!--", "all") />
	
	<cfreturn content />
</cffunction>

<cffunction name="write" output="false">
	<cfargument name="filename" />
	<cfargument name="content" />

	<cfif not directoryExists(getDirectoryFromPath(arguments.filename))>
		<cfdirectory action="create" directory="#getDirectoryFromPath(arguments.filename)#" mode="777" />
	</cfif>

	<cffile action="write" file="#arguments.filename#" output="#trim(arguments.content)#" mode="777" />
</cffunction>

</cfcomponent>
