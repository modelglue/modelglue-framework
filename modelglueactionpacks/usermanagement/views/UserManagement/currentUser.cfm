<cfset user = event.getValue("currentUser")>

<cfoutput>
<cfif isObject(user) and user.getIsLoggedIn(user)>
You're logged in as #user.getUsername()#.  <a href="#event.linkTo("userManagement.logout")#">Log out</a>.
<cfelse>
You're not logged in.  <a href="#event.linkTo("userManagement.loginScreen")#">Log in</a>.
</cfif>
</cfoutput>

