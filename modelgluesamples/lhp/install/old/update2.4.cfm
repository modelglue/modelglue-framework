<!---
This script will update your issues to use the new attachments table.
You MUST first update your database to add the new lh_attachments table 
first. If you do not, the world will come to an end and I will be very 
disappointed in you.

Note that the new table supports remembering your original filename. Since
I didn't support this in the older LHP, you will see the unique filename for
your attachment in the front end. For future uploads, you will see the filename
from your own system.
--->

<!--- set this DSN to the right value --->
<cfset dsn = "lighthousepro">

<!--- get all issues with attachments --->
<cfquery name="issues" datasource="#dsn#">
select	id, attachment
from	lh_issues
where	attachment != ''
</cfquery>

<cfoutput>
<p>
Out of your old issues, #issues.recordCount# have attachments.
</p>
</cfoutput>

<cfloop query="issues">
	<!--- You shouldn't run this script twice, but I can prevent dupes. --->
	<cfquery name="check" datasource="#dsn#">
	select	id
	from	lh_attachments
	where	issueidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#id#">
	and		attachment = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attachment#">
	</cfquery>
	
	<cfif check.recordCount is 0>
		<cfquery datasource="#dsn#">
		insert into lh_attachments(id, issueidfk, attachment, filename)
		values(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#createUUID()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#id#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attachment#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attachment#">
		)
		</cfquery>
	</cfif>
</cfloop>		
	
<p>
Done updating tables.
</p>