<cfcomponent displayName="ViewCollection" output="false" hint="I am a collection of rendered views.">

<cffunction name="init" access="public" returnType="any" output="false" hint="I build a new ViewCollection.">
  <cfset variables.viewCollection = structNew() />
  <cfset variables.finalViewKey = "" />
  <cfreturn this />
</cffunction>

<cffunction name="addRenderedView" access="public" returnType="void" output="false" hint="I add a rendered view to the collection.">
  <cfargument name="key" type="string" required="true" hint="I am the name of the view to add.">
  <cfargument name="content" type="string" required="true" hint="I am the HTML of the view.">
  <cfargument name="append" type="boolean" required="false" default="false" hint="Should the HTML be appended on to an existing view of the same name?">
  
  <cfif not append or not structKeyExists(variables.viewCollection, arguments.key)>
    <cfset variables.viewCollection[arguments.key] = arguments.content />
  <cfelse>
    <cfset variables.viewCollection[arguments.key] = variables.viewCollection[arguments.key] & arguments.content />
  </cfif>
  
  <cfset variables.finalViewKey = arguments.key />
</cffunction>

<cffunction name="getView" access="public" output="false" hint="I get a rendered view by name.">
  <cfargument name="name" required="true" hint="I am the name of the view to get.">
<cftry>
   <cfreturn variables.viewCollection[arguments.name] />
   <cfcatch>
   	<cfreturn "" />
   </cfcatch>
 </cftry>
</cffunction>

<cffunction name="exists" access="public" returnType="string" output="false" hint="Does a view with a given name exist in this collection?">
  <cfargument name="name" type="string" required="true" hint="I am the name of the view to check.">
    <cfreturn structKeyExists(variables.viewCollection, arguments.name) />
</cffunction>

<cffunction name="getAll" access="public" returnType="struct" output="false" hint="I get all rendered views (by value).">
	<cfreturn duplicate(variables.viewCollection) />
</cffunction>

<cffunction name="getFinalView" access="public" output="false" hint="I get the last view entered into the view collection.">
  <cfif structKeyExists(viewCollection, variables.finalViewKey)>
    <cfreturn variables.viewCollection[variables.finalViewKey] />
  <cfelse>
    <cfreturn "" />
  </cfif>
</cffunction>

<cffunction name="getFinalViewKey" access="public" output="false" hint="I get the key of last view entered into the view collection.">
	<cfreturn variables.finalViewKey />
</cffunction>

</cfcomponent>