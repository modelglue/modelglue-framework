<cfcomponent displayName="ViewRenderer" output="false" hint="I am responsible for rendering views.">

<cffunction name="init" access="public" returnType="any" output="false" hint="I build a new view renderer.">
  <cfreturn this />
</cffunction>

<cffunction name="renderView" output="false" hint="I render a view and return the resultant HTML.">
  <cfargument name="eventContext" type="any" hint="Event context in which this view is being rendered.">
  <cfargument name="view" type="any" hint="I am the view to render.">

	<cfset var i = "" />
	<cfset var result = "" />
	
	<!--- TODO: configure! --->
	<cfset var viewMapping = "/ModelGlue/gesture/view/test/views" />

  <cfloop collection="#arguments.view.values#" item="i">
    <cfif arguments.view.values[i].overwrite or not arguments.eventContext.exists(i)>
  	  <cfset arguments.eventContext.setValue(i, arguments.view.values[i].value) />
    </cfif>
  </cfloop>

  <cfsavecontent variable="result"><cfmodule template="/ModelGlue/gesture/view/ViewRenderer.cfm" includepath="#viewMapping#/#view.template#" viewstate="#arguments.eventContext#" viewcollection="#arguments.eventContext.getViewCollection()#"></cfsavecontent>
	
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