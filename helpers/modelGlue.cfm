<cffunction name="showErrors" output="true">
	<cfargument name="errorCollection" />
	<cfargument name="property" default="" />

	<cfset var errors = "" />
	<cfset var i = "" />
	
	<cfif isObject(errorCollection)>
		<cfset errors = arguments.errorCollection.getErrors() />
		
		<cfif structKeyExists(errors, arguments.property)>
			<div class="error">
				<cfoutput>
					<cfloop from="1" to="#arrayLen(errors[arguments.property])#" index="i">
						#errors[arguments.property][i]#<br />
					</cfloop>
				</cfoutput>
			</div>	
		</cfif>
	</cfif>
</cffunction>