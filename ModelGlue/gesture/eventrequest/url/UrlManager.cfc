<cfcomponent output="false" hint="Default URL manager that uses standard query string syntax for determining event names and building URLs.">

<cffunction name="init" output="false" hint="Constructor.">
	<cfset variables._mg = "" />
	<cfreturn this />
</cffunction>

<cffunction name="setModelGlue" output="false" hint="Sets the core Model-Glue framework instance this URL manager is concerned with.">
	<cfargument name="modelglue" required="true" hint="Instance of ModelGlue." />
	<cfset variables._mg = arguments.modelglue />
</cffunction>


<cffunction name="populateLocation" output="false" hint="Receives an event context and populates the ""self"", ""myself"", and ""eventValue"" values.">
	<cfargument name="eventContext" />
	
	<cfset var eventValue = variables._mg.configuration.eventValue />

	<cfset arguments.eventContext.setValue("eventValue", variables._mg.configuration.eventValue) />
	<cfset arguments.eventContext.setValue("self", variables._mg.configuration.defaultTemplate) />
	<cfset arguments.eventContext.setValue("myself", "#variables._mg.configuration.defaultTemplate#?#variables._mg.configuration.eventValue#=") />
</cffunction>

<cffunction name="extractValues" output="false" hint="Extracts values that should be treated as URL parameters.  In the default UrlManager, this simply returns the URL scope.">
	<cfreturn url />
</cffunction>

<cffunction name="linkTo" output="false" hint="Builds a link to the specified event, appending the listed values from the context and the anchor position specified.">
	<cfargument name="event" default="" hint="The event to which the url should link." />
	<cfargument name="append" default="" hint="The list of values to append." />
	<cfargument name="anchor" default="" hint="The anchor literal for the resultant URL." />
	<cfargument name="eventContext" default="" hint="Required if using append." />
	<cfargument name="preferredContext" default="" hint="An optional context to use as a source for the values to append." />
		
	<cfset var link = "#variables._mg.configuration.defaultTemplate#?#variables._mg.configuration.eventValue#=" />
	<cfset var i = "" />
	
	<!--- Add the event --->
	<cfset link = link & arguments.event />
	

	<!--- Add values --->
	<cfloop list="#arguments.append#" index="i">
		<cfif isStruct(arguments.preferredContext) and structKeyExists(arguments.preferredContext, i)>
			<cfset link = link & "&#i#=#urlEncodedFormat(arguments.preferredContext[i])#" />
		<cfelse>
			<cfset link = link & "&#i#=#urlEncodedFormat(arguments.eventContext.getValue(i))#" />
		</cfif>
	</cfloop>
	
	<!--- Add anchor --->
	<cfif len(arguments.anchor)>
		<cfset link = link & "###arguments.anchor#" />
	</cfif>
	
	<cfreturn link />
</cffunction>

<cffunction name="formatUrlParameter" output="false" hint="Formats a key/value pair for the URL.">
	<cfargument name="key" />
	<cfargument name="value" />
	
	<cfreturn "&#arguments.key#=#arguments.value#" />
</cffunction>

</cfcomponent>