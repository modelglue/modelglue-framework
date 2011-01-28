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


<cfcomponent displayname="ValidationService" output="false" hint="I am the default validation service.">

<cffunction name="init" access="public" returntype="any" output="false">
	<cfreturn this />
</cffunction>

<cffunction name="validate" access="public" returntype="any" output="false" hint="I attempt to validate an object, returning a ValidationErrorCollection">
	<cfargument name="table" type="any" required="true" hint="The name of the type of object" />
	<cfargument name="record" type="any" required="true" hint="The actual business object" />

	<cfreturn variables.Framework.getOrmAdapter().validate(arguments.table, arguments.record) />
</cffunction>

<cffunction name="getFramework" access="public" output="false" returntype="any">
	<cfreturn variables.Framework />
</cffunction>

<cffunction name="setFramework" access="public" output="false" returntype="void">
	<cfargument name="Framework" type="any" required="true" />
	<cfset variables.Framework = arguments.Framework />
</cffunction>



</cfcomponent>
