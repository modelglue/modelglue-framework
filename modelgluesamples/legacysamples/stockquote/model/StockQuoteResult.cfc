<!---
LICENSE INFORMATION:

Copyright 2007, Joe Rinehart
 
Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. 

You may obtain a copy of the License at 

	http://www.apache.org/licenses/LICENSE-2.0 
	
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.

VERSION INFORMATION:

This file is part of Model-Glue Model-Glue: ColdFusion (2.0.304).

The version number in parenthesis is in the format versionNumber.subversion.revisionNumber.
--->


<cfcomponent>
	<cffunction name="init">
		<cfset variables.errors = createObject("component", "ModelGlue.Util.ValidationErrorCollection") />
		<cfset variables.result = "" />
		<cfset variables.symbol = "" />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="AddError">
		<cfargument name="Property">
		<cfargument name="Message">
		<cfset variables.errors.addError(arguments.property, arguments.message) />
	</cffunction>
	
	<cffunction name="GetErrors">
		<cfreturn variables.errors.getErrors() />
	</cffunction>
	
	<cffunction name="setResult">
		<cfargument name="value">
		<cfset variables.result = arguments.value />
	</cffunction>
	
	<cffunction name="getResult">
		<cfreturn variables.result />
	</cffunction>
	
	<cffunction name="setSymbol">
		<cfargument name="value">
		<cfset variables.symbol = arguments.value />
	</cffunction>

	<cffunction name="getSymbol">
		<cfreturn variables.symbol />
	</cffunction>
</cfcomponent>