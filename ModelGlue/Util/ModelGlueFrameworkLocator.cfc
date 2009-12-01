<cfcomponent output="false" hint="""Static"" component for finding instances of Model-Glue.">

<cffunction name="findInScope" output="false" returntype="array" hint="Finds all or specific instances of Model-Glue within a given scope (or any struct, for that matter).">
	<cfargument name="scope" type="struct" required="true" />
	<cfargument name="scopeKey" type="string" required="false" />
	
	<cfset var key = "" />
	<cfset var mgInstance = "" />
	<cfset var result = arrayNew(1) />
	
	<!--- Find ModelGlue instances in the application scope. --->
	<cfloop collection="#scope#" item="key">
		<cfif isObject(scope[key]) and getMetadata(scope[key]).name eq "ModelGlue.gesture.ModelGlue">
			<cfif not structKeyExists(arguments, "scopeKey") or arguments.scopeKey eq key>
				<cfset arrayAppend(result, scope[key]) />
			</cfif>
		</cfif>
	</cfloop>
	
	<cfreturn result />
</cffunction>

</cfcomponent>