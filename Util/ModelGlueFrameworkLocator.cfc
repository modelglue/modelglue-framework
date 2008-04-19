<cfcomponent output="false" hint="""Static"" component for finding instances of Model-Glue.">

<cffunction name="findInScope" output="false" returntype="array" hint="Finds all instances of Model-Glue within a given scope (or any struct, for that matter).">
	<cfargument name="scope" type="struct" required="true" />
	
	<cfset var key = "" />
	<cfset var mgInstance = "" />
	<cfset var result = arrayNew(1) />
	
	<!--- Find _any_ ModelGlue instances in the application scope. --->
	<cfloop collection="#scope#" item="key">
		<cfif isObject(scope[key]) and getMetadata(scope[key]).name eq "ModelGlue.gesture.ModelGlue">
			<cfset arrayAppend(result, scope[key]) />
		</cfif>
	</cfloop>
	
	<cfreturn result />
</cffunction>

</cfcomponent>