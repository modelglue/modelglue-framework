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


<cfcomponent  extends="modelgluetests.unittests.gesture.ModelGlueAbstractTestCase">
	<!--- Created by John Mason, mason@fusionlink.com--->
	<!--- Date: Jul 24, 2009--->
	<!---Uses the 'buster' test dummy app to unit test the remoting services--->
	
	<cfset variables.instance = StructNew() />

	<!---May need to alter this your particular environment--->
	<cfset variables.instance.busterURL = "http://#cgi.server_name#:#cgi.server_port#/modelgluesamples/buster" />

	<cffunction name="setUp" returntype="void" access="public" hint="put things here that you want to run before each test">
		<cfset var local = structNew() />
		<cftry>
			<cfhttp method="Post" timeout="10" result="local.cfhttp" url="#variables.instance.busterURL#" />			
			<cfcatch><cfset local.cfhttp.filecontent = "" /></cfcatch>
		</cftry>		
	</cffunction>

	<cffunction name="testJSONRemotingCall" access="public" returntype="void">  
		<cfset var local = StructNew() />

		<cftry>
			<cfhttp method="Post" timeout="10" result="local.cfhttp" url="#variables.instance.busterURL#/RemotingService.cfc?method=executeEvent&returnformat=json&queryFormat=column">
				<cfhttpparam type="Formfield" name="eventName" value="get.users" />
				<cfhttpparam type="Formfield" name="returnValues" value="users" />
			</cfhttp>
			<cfcatch><cfset local.cfhttp.filecontent = "" /></cfcatch>
		</cftry>

		<cfset local.validresponse = "{""users"":{""ROWCOUNT"":12,""COLUMNS"":[""NAME""],""DATA"":{""name"":[""Person-1"",""Person-2"",""Person-3"",""Person-4"",""Person-5"",""Person-6"",""Person-7"",""Person-8"",""Person-9"",""Person-10"",""Person-11"",""Person-12""]}}}" />

		<!---The compare() will result in a 0 if good -- trim() used to prevent test failure due to trailing whitespace in HTTP content --->
		<!--- Making this comparison case insensitive because of the unfathomable key casing issues between different version of CF --->
		<cfset assertFalse(compareNoCase(trim(local.cfhttp.filecontent),local.validresponse),"#local.cfhttp.filecontent#" ) />	
		
	</cffunction>

	<cffunction name="testWDDXRemotingCall" access="public" returntype="void">  
		<cfset var local = StructNew() />

		<cftry>
			<cfhttp method="Post" timeout="10" result="local.cfhttp" url="#variables.instance.busterURL#/RemotingService.cfc?method=executeEvent">
				<cfhttpparam type="Formfield" name="eventName" value="get.users" />
				<cfhttpparam type="Formfield" name="returnValues" value="users" />
			</cfhttp>
			<cfcatch><cfset local.cfhttp.filecontent = "" /></cfcatch>
		</cftry>

		<cfset local.validresponse = "<wddxPacket version='1.0'><header/><data><struct><var name='users'><recordset rowCount='12' fieldNames='name' type='coldfusion.sql.QueryTable'><field name='name'><string>Person-1</string><string>Person-2</string><string>Person-3</string><string>Person-4</string><string>Person-5</string><string>Person-6</string><string>Person-7</string><string>Person-8</string><string>Person-9</string><string>Person-10</string><string>Person-11</string><string>Person-12</string></field></recordset></var></struct></data></wddxPacket>" />

		<!---The compare() will result in a 0 if good -- trim() used to prevent test failure due to trailing whitespace in HTTP content--->
		<cfset assertFalse(compare(trim(local.cfhttp.filecontent),local.validresponse)) />	
	</cffunction>
			
	<cffunction name="testForEventNameInReturnValues" access="public" returntype="void">  
		<cfset var local = StructNew() />

		<cftry>
			<cfhttp method="Post" timeout="10" result="local.cfhttp" url="#variables.instance.busterURL#/RemotingService.cfc?method=executeEvent&returnformat=json">
				<cfhttpparam type="Formfield" name="eventName" value="get.empty" />
				<cfhttpparam type="Formfield" name="returnValues" value="event" />
			</cfhttp>
			<cfcatch><cfset local.cfhttp.filecontent = "" /></cfcatch>
		</cftry>

		<cfset local.validresponse = "{""event"":""get.empty""}" />

		<!---The compare() will result in a 0 if good -- trim() used to prevent test failure due to trailing whitespace in HTTP content --->
		<cfset assertFalse(compare(trim(local.cfhttp.filecontent),local.validresponse),"#local.cfhttp.filecontent#" ) />	
		
	</cffunction>
			
	<cffunction name="testForOnRequestStartValueInReturnValues" access="public" returntype="void">  
		<cfset var local = StructNew() />

		<cftry>
			<cfhttp method="Post" timeout="10" result="local.cfhttp" url="#variables.instance.busterURL#/RemotingService.cfc?method=executeEvent&returnformat=json">
				<cfhttpparam type="Formfield" name="eventName" value="get.empty" />
				<cfhttpparam type="Formfield" name="returnValues" value="onRequestStartTest" />
			</cfhttp>
			<cfcatch><cfset local.cfhttp.filecontent = "" /></cfcatch>
		</cftry>

		<cfset local.validresponse = "{""onRequestStartTest"":""onRequestStartTest""}" />

		<!---The compare() will result in a 0 if good -- trim() used to prevent test failure due to trailing whitespace in HTTP content --->
		<cfset assertFalse(compare(trim(local.cfhttp.filecontent),local.validresponse),"#local.cfhttp.filecontent#" ) />	
		
	</cffunction>

</cfcomponent>
