<cfcomponent output="false">

	<cfset variables.instance = StructNew()/>

	<cffunction name="init" access="public" output="false" returntype="Users">
		<cfreturn this/>
	</cffunction>

	<cffunction name="getUsers" access="remote" output="false" returntype="any">
		<cfset var local = StructNew()/>
		<cfset local.myQuery = QueryNew("name","varchar")>
		<cfloop from="1" to="12" index="local.j">
			<cfset QueryAddRow(local.myQuery, 1)>
			<cfset QuerySetCell(local.myQuery, "name", "Person-#local.j#", local.j)>
		</cfloop>
		<cfreturn local.myQuery/>
	</cffunction>

</cfcomponent>