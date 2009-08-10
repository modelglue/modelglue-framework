<!---
	The purpose of this script is to update the issues
	table with publicid values. It will NOT add the columns.
	You are going to have to add the columns themselves, please
	check the readme.txt file for information on what columns you must
	add. 
--->

<!--- set this to your LHP dsn --->
<cfset dsn = "lighthousepro">

<cfquery name="issues" datasource="#dsn#">
select		id, projectidfk, name
from		issues
order by 	projectidfk, created asc
</cfquery>

<cfoutput group="projectidfk" query="issues">
	<b>projectidfk=#projectidfk#</b><br>
	<cfset counter = 0>

		<cfoutput>
			<cfset counter = counter + 1>
			issue: #name#, publicid will be #counter#<br>
			<cfquery datasource="#dsn#">
			update	issues
			set		publicid = <cfqueryparam cfsqltype="cf_sql_integer" value="#counter#">
			where	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#id#">	
			</cfquery>
		</cfoutput>
</cfoutput>