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


<cfcomponent hint="Collects and displays messages throughout a request.">

	<!--- init --->
	<cffunction name="init" access="public" output="false">

		<cfif NOT structKeyExists( session, "MessageQuery")>
			<cfset initializeMessages() />
		</cfif>

		<cfreturn this />
	</cffunction>

	<cffunction name="addError" access="public" output="false" hint="Appends an error message">
		<cfargument name="Message" required="yes" />
		<cfargument name="Key" default="" />
		
		<cfset AddMessage('Error', arguments.Message, arguments.key) />
	</cffunction>

	<cffunction name="addInfo" access="public" output="false" hint="Appends an info message">
		<cfargument name="Message" required="yes" />
		<cfargument name="Key" default="" />
		<cfset AddMessage('Info', arguments.Message, arguments.key) />
	</cffunction>

	<cffunction name="addSuccess" access="public" output="false" hint="Appends a success message">
		<cfargument name="Message" required="yes" />
		<cfargument name="Key" default="" />
		<cfset AddMessage('Success', arguments.Message, arguments.key) />
	</cffunction>

	<cffunction name="getAllMessages" access="public" output="false" hint="Returns a query of all messages.">
		<cfset var SavedMessages=duplicate(session.MessageQuery) />
		<cfif isQuery( SavedMessages ) IS false >
			<cfset initializeMessages() />
			<cfset SavedMessages=duplicate(session.MessageQuery) />
		</cfif>
		<!--- clear messages --->
		<cfset initializeMessages() />

		<cfreturn SavedMessages />
	</cffunction>
	
	<cffunction name="exportMessageStruct" access="public" output="false" hint="Returns a query of messages with a key messages.">
		<cfset var SavedMessages=duplicate(session.MessageQuery) />
		<cfset var returnStruct  = structNew() />
		<cfloop query="SavedMessages">
			<cfif len( trim( SavedMessages.key ) )>
				<cfset returnStruct[ SavedMessages.key ] = SavedMessages.Message />
			</cfif>
		</cfloop>
		<!--- clear messages --->
		<cfset initializeMessages() />

		<cfreturn returnStruct />
	</cffunction>
	
	<cffunction name="hasKey" output="false" access="public" returntype="boolean" hint="I check to see if there is a specific key in the message query">
		<cfargument name="key" type="string" required="true"/>
			<cfset var FindKey="" />
			<cfquery name="FindKey" dbtype="query">
				SELECT count(1)
				FROM session.MessageQuery
				WHERE [Key] = '#arguments.key#'
			</cfquery>

			<cfreturn FindKey.Recordcount gt 0 />
	</cffunction>

	<cffunction name="hasError" access="public" output="false" hint="Returns true if any errors exist in the message collection.">

		<cfset var CountRows="" />

		<cfquery name="CountRows" dbtype="query">
			SELECT count(1)
			FROM session.MessageQuery
			WHERE Type='Error'
		</cfquery>

		<cfreturn CountRows.Recordcount gt 0 />
	</cffunction>

	<cffunction name="getCount" access="public" output="false" hint="Returns number of messages in collection by type.">
		<cfargument name="Type" default="All" />

		<cfset var CountRows="" />

		<cfif arguments.Type is 'All'>
			<cfset CountRows=session.MessageQuery />
		<cfelse>
			<cfquery name="CountRows" dbtype="query">
				SELECT *
				FROM session.MessageQuery
				WHERE Type='#arguments.Type#'
			</cfquery>

		</cfif>
		<cfset CountRows=CountRows.Recordcount />
		<cfreturn CountRows />
	</cffunction>

	<!--- private: add Message --->
	<cffunction name="addMessage" access="private" output="false" hint="Appends a message to the message collection.">
		<cfargument name="Type" required="yes">
		<cfargument name="Message" required="yes">
		<cfargument name="Key" default="">
		
		<cfif NOT structKeyExists( session, "MessageQuery")>
			<cfset initializeMessages() />
		</cfif>

		<cfset queryaddrow(session.MessageQuery) />
		<cfset querysetcell(session.MessageQuery, 'Type', arguments.Type) />
		<cfset querysetcell(session.MessageQuery, 'Message', arguments.Message) />
		<cfset querysetcell(session.MessageQuery, 'Key', arguments.Key) />
	</cffunction>
	
	<cffunction name="initializeMessages" output="false" access="private" returntype="void" hint="I initialize a blank Message Query">
		<cfset session.MessageQuery = querynew('Type,Message,Key') />	
	</cffunction>

	
</cfcomponent>

