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


<cfcomponent hint="I am a bean ideal for holding config settings." output="false">
  
  <cffunction name="Init" access="public" output="false" hint="I build a new SimpleConfig bean.">
    <cfset variables.config = structNew() />
    <cfreturn this />
  </cffunction>
  
  <cffunction name="SetConfig" access="public" return="void" output="false" hint="Set property: config">
    <cfargument name="value" type="struct"/>
		
		<cfset var i = "" />
		
    <cfset variables.config=arguments.value />
		
		<cfloop collection="#arguments.value#" item="i">
			<cfif not structKeyExists(this, i)>
				<cfset this[i] = arguments.value[i] />
			</cfif>
		</cfloop>
  </cffunction>
  
  <cffunction name="GetConfig" access="public" return="struct" output="false" hint="Get property: config">
    <cfreturn duplicate(variables.config) />
  </cffunction>
  
  <cffunction name="GetConfigSetting" access="public" return="any" output="false" hint="I get a config setting from the config by name.">>
    <cfargument name="name" required="true" type="string">
    
    <cfreturn variables.config[arguments.name] />
  </cffunction>
</cfcomponent>
