<cfcomponent output="false" displayName="User Service">

	
	<cffunction name="init" access="public" returnType="mailService" output="false">
		<cfargument name="settings" type="any" required="true">
		
		<cfset variables.config = arguments.settings.getConfig()>	
	
		<!--- make one string for mail server. Thanks to Andrew Penhorwood --->
		<cfif variables.config.mailserver neq "">
			<cfif variables.config.mailport neq "">
				<cfset variables.mailserver = variables.config.mailserver & ":" & variables.config.mailport>
			</cfif>			
			<cfif variables.config.mailusername neq "">
	   			<cfset variables.mailserver = variables.config.mailusername & ":" & variables.config.mailpassword & "@" & variables.config.mailserver>
			</cfif>
		<cfelse>
			<cfset variables.mailserver = "">
		</cfif>		
		<cfreturn this>
	</cffunction>	

	<!---
	Generic sender. Always sets from address to config value. May change.
	--->
	<cffunction name="sendMail" access="public" returnType="void" output="false">
		<cfargument name="to" type="query" required="true" hint="Assumes query where emailaddress is a col">
		<cfargument name="fromname" type="any" required="true">
		
		<cfargument name="subject" type="string" required="true">
		<cfargument name="replyby" type="string" required="true">
		<cfargument name="severity" type="string" required="true">
		
		<cfargument name="textbody" type="string" required="true">
		<cfargument name="htmlbody" type="string" required="true">
		
		<cfif variables.mailserver is not "">
			<cfmail server="#variables.mailserver#" query="arguments.to" to="#emailaddress#" from="#variables.config.adminEmail# (#arguments.fromName#)" subject="#subject#">
			<cfif len(arguments.replyby)>
				<cfmailparam name="Reply-By" value="#arguments.replyby#">
			</cfif>
			<cfmailparam name="Importance" value="#arguments.severity#">
			<cfmailparam name="X-Message-Flag" value="Follow up">
			<cfmailpart type="text">
				#arguments.textbody#
			</cfmailpart>
			<cfmailpart type="html">
				#arguments.htmlbody#
			</cfmailpart>
			</cfmail>
		<cfelse>
			<cfmail query="arguments.to" to="#emailaddress#" from="#variables.config.adminEmail# (#arguments.fromName#)" subject="#arguments.subject#">
			<cfif len(arguments.replyby)>
				<cfmailparam name="Reply-By" value="#arguments.replyby#">
			</cfif>
			<cfmailparam name="Importance" value="#arguments.severity#">
			<cfmailparam name="X-Message-Flag" value="Follow up">
			<cfmailpart type="text">
				#arguments.textbody#
			</cfmailpart>
			<cfmailpart type="html">
				#arguments.htmlbody#
			</cfmailpart>
			</cfmail>
		</cfif>	
			
	</cffunction>

</cfcomponent>