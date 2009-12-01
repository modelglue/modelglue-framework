<cfset settings = event.getValue("settings")>
<cfset root = event.getValue("myself")>
<cfset loginError = event.getValue("loginError", 0)>
	
<cfoutput>
<div id="loginBox">

	<div id="loginForm">
		<h1 class="bgreplace">Lighthouse Pro Login</h1>
			<form action="#root#action.login" method="post" name="loginform">
			<div class="field clear">
				<label>Username:</label>
				<input type="text" name="username" id="username" class="bigInput" />
			</div>
			<div class="field clear">
				<label>Password:</label>
				<input type="password" name="password" class="bigInput" />
			</div>
			<input type="hidden" name="login" value="">
			<input type="image" name="loginimg" src="images/loginBtn.jpg" class="loginBtn"/>
		</form>
	</div>
	<cfif loginError>
		<br /><div class="error" align="center">The username/password you entered is incorrect. Please try again.</div>
	</cfif>			
	ver. <strong>#settings.version#</strong>

</div>
<script>
$(document).ready(function() {
	$("##username").focus()
})
</script>
</cfoutput>
