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


<cfcomponent output="false">

	<cfset variables.id = "" />
	<cfset variables.firstName = "" />
	<cfset variables.lastName = "" />
	<cfset variables.street = "" />
	<cfset variables.city = "" />
	<cfset variables.state = "" />
	<cfset variables.zip = "" />

	<cffunction name="init">
		<cfargument name="firstName" type="string" required="false" default="" />
		<cfargument name="lastName" type="string" required="false" default="" />
		<cfargument name="street" type="string" required="false" default="" />
		<cfargument name="city" type="string" required="false" default="" />
		<cfargument name="state" type="string" required="false" default="" />
		<cfargument name="zip" type="string" required="false" default="" />
		
		<cfinvoke component="#this#" method="setInfo" info="#arguments#" />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setInfo" access="public">
		<cfargument name="info" type="struct" required="true" />
		
		<cfset setFirstName(arguments.info.firstName) />
		<cfset setLastName(arguments.info.lastName) />
		<cfset setStreet(arguments.info.street) />
		<cfset setCity(arguments.info.city) />
		<cfset setState(arguments.info.state) />
		<cfset setZip(arguments.info.zip) />
	</cffunction>
	
	<cffunction name="getInfo" access="public">
    <cfreturn variables />
	</cffunction>
		
	<cffunction name="setId" access="public" output="false">
		<cfargument name="id" type="string" required="true" />
		<cfset variables.id = arguments.id />
	</cffunction>
	<cffunction name="getId" access="public" returntype="string" output="false">
		<cfreturn variables.id />
	</cffunction>
	
	<cffunction name="setFirstName" access="public" output="false">
		<cfargument name="firstName" type="string" required="true" />
		<cfset variables.firstName = arguments.firstName />
	</cffunction>
	<cffunction name="getFirstName" access="public" returntype="string" output="false">
		<cfreturn variables.firstName />
	</cffunction>
	
	<cffunction name="setLastName" access="public" output="false">
		<cfargument name="lastName" type="string" required="true" />
		<cfset variables.lastName = arguments.lastName />
	</cffunction>
	<cffunction name="getLastName" access="public" returntype="string" output="false">
		<cfreturn variables.lastName />
	</cffunction>
	
	<cffunction name="setStreet" access="public" output="false">
		<cfargument name="street" type="string" required="true" />
		<cfset variables.street = arguments.street />
	</cffunction>
	<cffunction name="getStreet" access="public" returntype="string" output="false">
		<cfreturn variables.street />
	</cffunction>
	
	<cffunction name="setCity" access="public" output="false">
		<cfargument name="city" type="string" required="true" />
		<cfset variables.city = arguments.city />
	</cffunction>
	<cffunction name="getCity" access="public" returntype="string" output="false">
		<cfreturn variables.city />
	</cffunction>
	
	<cffunction name="setState" access="public" output="false">
		<cfargument name="state" type="string" required="true" />
		<cfset variables.state = arguments.state />
	</cffunction>
	<cffunction name="getState" access="public" returntype="string" output="false">
		<cfreturn variables.state />
	</cffunction>
	
	<cffunction name="setZip" access="public" output="false">
		<cfargument name="zip" type="string" required="true" />
		<cfset variables.zip = arguments.zip />
	</cffunction>
	<cffunction name="getZip" access="public" returntype="string" output="false">
		<cfreturn variables.zip />
	</cffunction>

</cfcomponent>