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


<cfcomponent output="false" hint="""Static"" component for finding instances of Model-Glue.">

<cffunction name="findInScope" output="false" returntype="array" hint="Finds all or specific instances of Model-Glue within a given scope (or any struct, for that matter).">
	<cfargument name="scope" type="struct" required="true" />
	<cfargument name="scopeKey" type="string" required="false" />
	
	<cfset var key = "" />
	<cfset var mgInstance = "" />
	<cfset var result = arrayNew(1) />
	
	<!--- Find ModelGlue instances in the application scope. --->
	<cfloop collection="#scope#" item="key">
		<cfif isObject(scope[key]) and isTypeOf( "ModelGlue.gesture.ModelGlue", scope[key] )>
			<cfif not structKeyExists(arguments, "scopeKey") or arguments.scopeKey eq key>
				<cfset arrayAppend(result, scope[key]) />
			</cfif>
		</cfif>
	</cfloop>
	
	<cfreturn result />
</cffunction>
<!--- This could be refactored for isInstanceOf once we drop CF7 support.  --->
<cffunction name="isTypeOf" output="false" access="public" returntype="any" hint="I check to see if this component extends another component somewhere in the inheritance chain">
	<cfargument name="type" type="string" required="true"/>	
	<cfargument name="instance" type="any" required="true"/>
	<cfset var componentMetadata = getMetadata( arguments.instance ) />
	<cfset var scope = componentMetadata.extends />
	<!--- Maybe the component is the component we want --->
	<cfif listFindNoCase( "#arguments.type#,#scope.name#", componentMetadata.name ) GT 0>
		<cfreturn true />
	</cfif>
	<!--- Ok, maybe it extends the component we want, so we'll rip over the metadata until we either find it, or hit the end of the road --->
	<cfloop condition="true">
		<!--- Check to see if this go-round has what we are looking for --->	
		<cfif scope.name IS arguments.type>
			<cfreturn true />
		<!--- Put the defensive position here so we don't spiral out of control. No more EXTENDS structs means the end of the inheritance tree --->
		<cfelseif structKeyExists( scope, "extends") IS false>
			<cfreturn false />
		</cfif>
		<!--- Set the scope to the next struct and let's spin the wheel again --->
		<cfset scope = scope.extends />		
	</cfloop>
	
</cffunction>

</cfcomponent>
