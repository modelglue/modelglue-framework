<cfcomponent displayName="ViewRenderer" output="false" hint="I am responsible for rendering views.">

<cffunction name="init" access="public" returnType="any" output="false" hint="I build a new view renderer.">
	<cfset variables._viewMappings = arrayNew(1) />
  <cfreturn this />
</cffunction>

<cffunction name="getViewMappings" output="false" hint="Gets the current list of view mappings.">
	<cfreturn variables._viewMappings />
</cffunction>
<cffunction name="addViewMapping" output="false" hint="Adds a new view mapping.">
	<cfargument name="viewMapping" type="string" />
	<cfset arrayAppend(variables._viewMappings, arguments.viewMapping) />
</cffunction>

<cffunction name="renderView" output="false" hint="I render a view and return the resultant HTML.">
	<cfargument name="eventContext" type="any" hint="Event context in which this view is being rendered.">
	<cfargument name="view" type="any" hint="I am the view to render.">
	<cfargument name="helpers" hint="I am the ""helpers"" scope available within the view." default="#structNew()#" />

	<cfset var i = "" />
	<cfset var j = "" />
	<cfset var includeFound = false />
	<cfset var template = "" />
	<cfset var result = "" />
	
	<cfloop collection="#arguments.view.values#" item="i">
	  <cfif arguments.view.values[i].overwrite or not arguments.eventContext.exists(i)>
		  <cfset arguments.eventContext.setValue(i, arguments.view.values[i].value) />
	  </cfif>
	</cfloop>

	<cfset includeFound = false />
	<cfloop from="1" to="#arrayLen(variables._viewMappings)#" index="i">
		<cfset template = variables._viewMappings[i] & "/" & arguments.view.template />
		<cflog text="#template# - #expandPath(template)# - #fileExists(expandPath(template))#" />
		<cfif fileExists(expandPath(template))>
			<cfset includeFound = true />
			<cfbreak />
		</cfif>	
	</cfloop>

	<cfif not includeFound>
		<cfthrow type="ViewRenderer.includeNotFound"
						 message="The template (#arguments.view.template#) was not found in any registered view mappings (#arrayToList(variables._viewMappings)#)." />
	</cfif>
	
	<cfsavecontent variable="result"><cfmodule template="/ModelGlue/gesture/view/ViewRenderer.cfm" includepath="#template#" viewstate="#arguments.eventContext#" viewcollection="#arguments.eventContext.getViewCollection()#" helpers="#arguments.helpers#"></cfsavecontent>
	
	<cfreturn result />
	<!---
	<cfset var result = "" />
	<cfset var v = "" />
	<cfset var i = "" />
	<cfset var viewstate = arguments.stateContainer />
	<cfset var viewCollection = arguments.viewCol />
  
  <cfloop collection="#arguments.StateValues#" item="i">
    <cfif arguments.StateValues[i].overwrite or not viewstate.exists(i)>
  	  <cfset viewstate.SetValue(i,arguments.StateValues[i].value) />
    </cfif>
  </cfloop>
  
  <cfsavecontent variable="result"><cfmodule template="/ModelGlue/unity/view/ViewRenderer.cfm" includepath="#arguments.includeUrl#" viewstate="#viewstate#" viewcollection="#viewcollection#"></cfsavecontent>

  <cfreturn result />
	--->
</cffunction>

</cfcomponent>