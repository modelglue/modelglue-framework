<cfcomponent displayname="MapCollection" output="false" hint="I am a generic collection of key/value pairs.">

<cffunction name="init" access="public" returnType="MapCollection" output="false" hint="I build a new MapCollection.">
	<cfargument name="values" required="false" default="#arrayNew(1)#" hint="A single structure or array of structure to merge into this collection." />

  	<cfset var i = "" />
	<cfset var tmp = "" />
	
	<cfif isStruct(values)>
		<cfset tmp = arguments.values />
		<cfset arguments.values = arrayNew(1) />
		<cfset arrayAppend(arguments.values, tmp) />
	<cfelseif not isArray(values)>
		<cfthrow type="ModelGlue.gesture.collections.MapCollection"
						 message="Invalid initial values type!" />
	</cfif>
	
  <cfset variables.values = structNew() />

  <cfloop to="#arrayLen(arguments.values)#" from="1" index="i">
    <cfset merge(arguments.values[i]) />
  </cfloop>
  
  <cfreturn this />
</cffunction>

<cffunction name="getAll" access="public" returnType="struct" output="false" hint="I get all values by reference.">
  <cfreturn variables.values />
</cffunction>

<cffunction name="setValue" access="public" returnType="void" output="false" hint="I set a value in the collection.">
  <cfargument name="name" hint="I am the name of the value.">
  <cfargument name="value" hint="I am the value.">

  <cfset variables.values[arguments.name] = arguments.value />
</cffunction>

<cffunction name="getValue" access="public" returnType="any" output="false" hint="I get a value from the collection.">
  <cfargument name="name" hint="I am the name of the value.">
  <cfargument name="default" required="false" type="any" hint="I am a default value to set and return if the value does not exist." />

  <cfif exists(arguments.name)>
    <cfreturn variables.values[arguments.name] />
  <cfelseif structKeyExists(arguments, "default")>
    <cfset setValue(arguments.name, arguments.default) />
    <cfreturn arguments.default />
  <cfelse>
    <cfreturn "" />
  </cfif>
</cffunction>

<cffunction name="removeValue" access="public" returnType="void" output="false" hint="I remove a value from the collection.">
  <cfargument name="name" type="string" required="true" hint="I am the name of the value.">
	
	<cfif exists(arguments.name)>
	  <cfset structDelete(variables.values, arguments.name) />
	</cfif>
</cffunction>

<cffunction name="exists" access="public" returnType="boolean" output="false" hint="I state if a value exists.">
  <cfargument name="name" type="string" required="true" hint="I am the name of the value.">
  <cfreturn structKeyExists(variables.values, arguments.name)>
</cffunction>

<cffunction name="merge" access="public" returnType="void" output="false" hint="I merge an entire struct into the collection.">
  <cfargument name="struct" type="struct" required="true" hint="I am the struct to merge." />
  
  <cfset var i = "" />
  
  <cfloop collection="#arguments.struct#" item="i">
    <cfset setValue(i, arguments.struct[i]) />
  </cfloop>
</cffunction>

</cfcomponent>