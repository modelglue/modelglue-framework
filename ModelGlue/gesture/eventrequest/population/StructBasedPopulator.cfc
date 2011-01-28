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


<cfcomponent output="false" hint="I populate an event context from a structure.">

<cffunction name="init" output="false">
	<cfreturn this />
</cffunction>

<cffunction name="populate" output="false" hint="I receive a structure and an event context and populate the event context from the structure.">
	<cfargument name="context" hint="EventContext to populate." />
	<cfargument name="source" type="struct" hint="Source data for population." />
	
	<cfset var i = "" />
	
	<cfloop collection="#arguments.source#" item="i">
		<cfset arguments.context.setValue(i, arguments.source[i]) />
	</cfloop> 
</cffunction>

</cfcomponent>
