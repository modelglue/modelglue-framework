<cfcomponent output="false" displayName="Severity Bean" hint="Manages a severity.">

	<cfset variables.instance = structNew() />
	<cfset variables.instance.id = 0 />
	<cfset variables.instance.name = "" />
	<cfset variables.instance.rank = 0 />
	
	<cffunction name="setID" returnType="void" access="public" output="false">
		<cfargument name="id" type="string" required="true">
		<cfset variables.instance.id = arguments.id>
	</cffunction>

	<cffunction name="getID" returnType="string" access="public" output="false">
		<cfreturn variables.instance.id>
	</cffunction>
	
	<cffunction name="setName" returnType="void" access="public" output="false">
		<cfargument name="name" type="string" required="true">
		<cfset variables.instance.name = arguments.name>
	</cffunction>
	
	<cffunction name="getName" returnType="string" access="public" output="false">
		<cfreturn variables.instance.name>
	</cffunction>	
	
	<cffunction name="setRank" returnType="void" access="public" output="false">
		<cfargument name="rank" type="numeric" required="true">
		<cfset variables.instance.rank = arguments.rank>
	</cffunction>
	
	<cffunction name="getRank" returnType="numeric" access="public" output="false">
		<cfreturn variables.instance.rank>
	</cffunction>
		
	<cffunction name="validate" returnType="array" access="public" output="false">
		<cfset var errors = arrayNew(1)>
		
		<cfif not len(trim(getName()))>
			<cfset arrayAppend(errors,"Name cannot be blank.")>
		</cfif>
		<cfif getRank() LTE 0>
			<cfset arrayAppend(errors, "Rank must be greater than zero.")>
		</cfif>

		<cfreturn errors>
	</cffunction>
	
	<cffunction name="getInstance" returnType="struct" access="public" output="false">
		<cfreturn duplicate(variables.instance)>
	</cffunction>

</cfcomponent>	