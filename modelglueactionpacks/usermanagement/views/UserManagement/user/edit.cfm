<cfimport prefix="common" taglib="/modelglueactionpacks/common/tags" /> 

<cfset user = event.getValue("user") />
<cfset validationErrors = event.getValue("validationErrors") />

<cfoutput>
<cfform action="#event.linkTo("userManagement.user.save")#" class="cssform">
	<input type="hidden" name="userId" value="#user.getUserId()#" />
	<fieldset>
		<legend>Edit User</legend>
		<common:formfield propertyname="username" label="Username:" required="true" validationErrors="#validationErrors#">
			<cfinput name="username" id="username" value="#user.getusername()#" type="text" required="false" message="Please enter a username." />
		</common:formfield>
		<common:formfield propertyname="password" label="Password:" required="true" validationErrors="#validationErrors#">
			<cfinput name="password" id="password" value="#event.getValue("password")#" type="password" required="false" message="Please enter a password." />
		</common:formfield>
		<common:formfield propertyname="password2" label="Password (again):" required="true" validationErrors="#validationErrors#">
			<cfinput name="password2" id="password2" value="#event.getValue("password2")#" type="password" required="false" message="Please re-enter your password." />
			<div class="hint">To change the user's password, enter it twice.  Otherwise, don't enter a password.</div>
		</common:formfield>
		<common:formfield propertyname="emailAddress" label="E-mail Address:" required="true" validationErrors="#validationErrors#">
			<cfinput name="emailAddress" id="emailAddress" value="#user.getemailAddress()#" type="text" required="false" validate="email" message="Please enter a valid e-mail address." />
		</common:formfield>
		<common:formcontrols>
			<input type="submit" value="Ok" />
			<a href="#event.linkTo("userManagement.user.list")#">Back to User List</a>
		</common:formcontrols>
	</fieldset>
</cfform>
</cfoutput>