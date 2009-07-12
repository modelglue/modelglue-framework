<!---
	Name         : C:\projects\lighthousepro\wwwroot\lighthousepro\install\hashpasswords.cfm
	Author       : Jeff Smallwood 
	Created      : 3/1/08
	Last Updated : 3/1/08
	History      : 
--->

<!--- Remove Me in order to run --->
<cfabort>

<cfoutput>
<cfif NOT application.plaintextpassword>
	<h2>Lighthouse Pro is already configured to use hashed passwords.</h2>
	There is no need to execute this file because your passwords are already stored in hashed format.</h2>
<cfelse>

	<cfparam name="form.hashpasswords" default="false">
	
	<cfif not form.hashpasswords><!--- We are not modifying the data yet --->
	
		<h2>Warning: Once you hash the passwords you can not go back!</h2>
		
		<cfif IsDefined("form.execute")><h3>Please check the checkbox below and submit again.</h3></cfif>
		
		<p>This file will modify <strong>all</strong> your current Lighthouse Pro account passwords.  
		It assumes they	are already stored in plain text (according to the LHP default file they are),
		 reads them in, and saves them back to the database as hashed values.</p>
		 
		<p>In addition, this script will automatically update your defaults.cfm file to reflect
			 the use of hashed passwords.</p>
			 
		<form action="hashpasswords.cfm" method="post">
			<input type="hidden" name="execute" value="true">
			<p><input type="checkbox" name="hashpasswords" value="true"> I understand the use of hashed passwords and want to convert
				my existing LHP accounts to this password storage method.</p>
				<input type="submit" value="Do it">
		</form>
		 
	
	<cfelse><!--- Do the change --->
		<cftry>
			<!--- transation the change of the accounts --->
			<Cftransaction action="begin">
				<Cfset users = application.usermanager.getUsers()>
				<cfloop query="users">
					<cfquery datasource="#application.dsn#" username="#application.username#" password="#application.password#">
						update lh_users
						set password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#hash(password,"SHA")#" maxlength="50">
						where id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#id#" maxlength="35">
					</cfquery>
				</cfloop>
				
				<!--- read the defaults.cfm file and update it --->
				<cffile action="read" file="#expandPath('../defaults.cfm')#" variable="defaults">
				<cfset startpos = FindNoCase("<plaintextpassword>",defaults)>
				<cfset endpos = FindNoCase("</plaintextpassword>",defaults,startpos)>
				<cfset currentvalue = Mid(defaults,startpos,endpos - startpos)>
				<Cfset defaults = replace(defaults,currentvalue,"<plaintextpassword>false")>
				<cffile action="write" output="#defaults#" file="#expandPath('../defaults.cfm')#">
				
			<Cftransaction action="commit"/>
			<Cfset blnOK = true>
		<cfcatch type="any">
			<Cftransaction action="rollback"/>
			<cfset blnOK = false>
			<cfset error = Duplicate(cfcatch)>
		</cfcatch>
		</cftry>
		
		<cfif blnOK>
			<h3>Success!</h3>
			<p>Your accounts have all be updated with hashed passwords and your defaults.cfm file has been automatically updated.</p>
			<p>You must now <strong>reinitialize Lighthouse Pro</strong> in order to start using the new settings.</p>
			<a href="../index.cfm?reinit=1">Click to reinitialize Now</a>
		<cfelse>
			<h3>Error</h3>
			<p>There was an error converting your accounts to hashed passwords. The error is below.</p>
			<cfdump var="#error#">
		</cfif>
		
	
	</cfif>
</cfif>
</cfoutput>
