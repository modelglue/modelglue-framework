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


<cfcomponent output="false" hint="Exposes Model-Glue application to remote clients.">

<cfset variables.locator = createObject("component", "ModelGlue.Util.ModelGlueFrameworkLocator") />

<cffunction name="getModelGlue" output="false">
	<cfset var mg = "" />
	
	<!--- Bootstrap MG by invoking the main template but blocking event execution. --->
	<cfset request._modelglue.bootstrap.blockEvent = 1 />
	
	<cfmodule template="#template#" />
	
	<!--- If this is an intialization request, retrieve the framework from the request bootstrapper --->
	<cfif request._modelglue.bootstrap.initializationRequest is true>
		<cfset mg = arrayNew(1) />
		<cfset mg[1] = request._modelGlue.bootstrap.framework />
	<!--- Otherwise, grab it from the application scope --->
	<cfelse>
		<cfset mg = variables.locator.findInScope(application, request._modelglue.bootstrap.appKey) />
		
		<cfif not arrayLen(mg)>
			<cfthrow message="Can't locate Model-Glue instance named #request._modelglue.bootstrap.appKey# in application scope!" />
		</cfif>
	</cfif>
	
	<cfreturn mg[1] />
</cffunction>


<cffunction name="executeEvent" output="false" access="remote" returntype="struct">
	<cfargument name="eventName" type="string" required="true" />
	<cfargument name="values" type="struct" required="false" default="#StructNew()#"/>
	<cfargument name="returnValues" type="string" required="false" default="" />
	
	<cfset var local = StructNew() />
	
	<cfset local.mg = getModelGlue() />
	<cfset local.result = StructNew() />
	
	<!--- Retrieve the "eventValue" config setting in order to set it from the "eventName" argument --->
	<cfset local.eventValue = local.mg.getConfigSetting("eventValue") />
	
	<!---
	Add the event name to the URL scope
	Note that this will also create a "url" structure for Flash remoting calls (does this work on non-Adobe CF engines?)
	--->
	<cfset url[local.eventValue] = arguments.eventName />
	
	<!---
	Append the arguments scope to the URL scope, thus populating the event with all arguments,
	including the nested keys of the "values" argument for Flash remoting calls
	--->
	<cfset structAppend(url, arguments.values) />
	
	<cfset local.event = local.mg.handleRequest() />
	
	<cfloop list="#arguments.returnValues#" index="local.i">
		<cfset local.result[local.i] = local.event.getValue(local.i) />
	</cfloop>
	
	<cftry>
		<cfset resetCFHtmlHead() />
		<cfcatch type="any">
			<cfset local.event.addTraceStatement("RemotingService", "An error occurred executing resetCFHtmlHead()", cfcatch.message, "WARNING") />
		</cfcatch>
	</cftry>
	<cfreturn local.result />
</cffunction>

<!--- 
Based on original function by Elliot Sprehn, found here
http://livedocs.adobe.com/coldfusion/7/htmldocs/wwhelp/wwhimpl/common/html/wwhelp.htm?context=ColdFusion_Documentation&file=00000271.htm
BlueDragon and Railo by Chris Blackwell
--->
<cffunction name="resetCFHtmlHead" output="false" access="public" returntype="void">
	<cfset var my = structnew() />

	<cfswitch expression="#trim(server.coldfusion.productname)#">

		<cfcase value="ColdFusion Server">
			<cfset my.out = getPageContext().getOut() />

			<!--- It's necessary to iterate over this until we get to a coldfusion.runtime.NeoJspWriter --->
			<cfloop condition="getMetaData(my.out).getName() is 'coldfusion.runtime.NeoBodyContent'">
				<cfset my.out = my.out.getEnclosingWriter() />
			</cfloop>

			<cfset my.method = my.out.getClass().getDeclaredMethod("initHeaderBuffer", arrayNew(1)) />
			<cfset my.method.setAccessible(true) />
			<cfset my.method.invoke(my.out, arrayNew(1)) />

		</cfcase>

		<cfcase value="BlueDragon">

			<cfset my.resp = getPageContext().getResponse() />

			<cfloop condition="true">
				<cfset my.parentf = my.resp.getClass().getDeclaredField('parent') />
				<cfset my.parentf.setAccessible(true) />
				<cfset my.parent = my.parentf.get(my.resp) />

				<cfif isObject(my.parent) AND getMetaData(my.parent).getName() is 'com.naryx.tagfusion.cfm.engine.cfHttpServletResponse'>
					<cfset my.resp = my.parent />
				<cfelse>
					<cfbreak />
				</cfif>
			</cfloop>

			<cfset my.writer = my.resp.getClass().getDeclaredField('writer') />
			<cfset my.writer.setAccessible(true) />
			<cfset my.writer = my.writer.get(my.resp) />

			<cfset my.headbuf = my.writer.getClass().getDeclaredField('headElement') />
			<cfset my.headbuf.setAccessible(true) />
			<cfset my.headbuf.get(my.writer).setLength(0) />

		</cfcase>

		<cfcase value="Railo">

			<cfset my.out = getPageContext().getOut() />

			<cfloop condition="getMetaData(my.out).getName() is 'railo.runtime.writer.BodyContentImpl'">
				<cfset my.out = my.out.getEnclosingWriter() />
			</cfloop>

			<cfset my.headData = my.out.getClass().getDeclaredField("headData") />
			<cfset my.headData.setAccessible(true) />
			<cfset my.headData.set(my.out, createObject("java", "java.lang.String").init("")) />

		</cfcase>

	</cfswitch>

</cffunction>

</cfcomponent>
