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


<cfcomponent displayname="Controller" output="false" hint="I am a sample model-glue controller." extends="ModelGlue.Core.Controller">

<!--- Constructor --->
<cffunction name="Init" access="Public" returnType="Controller" output="false" hint="I build a new SampleController">
  <cfargument name="ModelGlue" required="true" type="ModelGlue.ModelGlue" />
  <cfargument name="InstanceName" required="true" type="string" />
  <cfset super.Init(arguments.ModelGlue) />

	<!--- Controllers are in the application scope:  Put any application startup code here. --->

	<!--- This holds an instance of the stockquote service --->
	<cfset variables._stockservice = "" />
		
  <cfreturn this />
</cffunction>

<!--- This "Set" method will automatically be called by ColdSpring --->
<cffunction name="SetStockQuoteService"  access="public" returntype="void" output="false">
	<cfargument name="StockQuoteService" type="any" required="true">
	<cfset variables._stockservice = arguments.StockQuoteService />
</cffunction>
<cffunction name="GetStockQuoteService" access="public" returntype="any" output="false">
	<cfreturn variables._stockservice />
</cffunction>


<!--- Functions specified by <message-listener> tags --->
<cffunction name="OnRequestStart" access="Public" returntype="void" output="false" hint="I am an event handler.">
  <cfargument name="event" type="ModelGlue.Core.Event" required="true">
</cffunction>

<cffunction name="OnRequestEnd" access="Public" returntype="void" output="false" hint="I am an event handler.">
  <cfargument name="event" type="ModelGlue.Core.Event" required="true">
</cffunction>

<cffunction name="GetGreeting" access="Public" returnType="void" output="false" hint="I am an event handler.">
	<cfargument name="event" type="ModelGlue.Core.Event" required="true">
	<cfset arguments.event.SetValue("Greeting", "Hello, I am the Controller!") />
</cffunction>

<cffunction name="GetStockQuote" access="Public" returnType="void" output="false" hint="I am an event handler.">
	<cfargument name="event" type="ModelGlue.Core.Event" required="true">
	
	<cfset var symbol = arguments.event.GetValue("symbol") />
	<cfset var QuoteGetter = GetStockQuoteService() />
	<cfset var result = "" />
	
	<cfif not len(symbol)>
		<cfset symbol = arguments.event.GetArgument("DefaultSymbol") />
	</cfif>
	
	<cftry>
		<cfset result = getFromCache("stockQuoteResult_" & symbol) />
		<cfset arguments.event.trace("GetQuote()", "Retrieved quote for #symbol# from cache!") />
		<cfcatch>
			<cfset result = QuoteGetter.GetQuote(symbol) />
			<cfset addToCache("stockQuoteResult_" & symbol, result) />
			<cfset arguments.event.trace("GetQuote()", "Added quote for #symbol# to cache!") />
		</cfcatch>
	</cftry>
	
	<cfset arguments.event.setValue("symbol", result.getSymbol()) />
	<cfset arguments.event.setValue("price", result.getResult()) />
	
	<cfif result.getResult() lt 0>
		<cfset arguments.event.addResult("badSymbol") />
	</cfif>
</cffunction>

</cfcomponent>

