<cfsilent>
	<cfset event.copyToScope( variables, "UserMsg")>
	<cfset messages = UserMsg.getAllMessages() />
	<cfset hasMessages = messages.recordcount GT 0 />
</cfsilent>
<!-- Start Message -->
<cfif hasMessages IS true>
<ul>
<cfloop query="messages">
	<li class="#type#">#message# </li>
</cfloop>
</ul>
</cfif>
<!-- End Message -->
