<cfcomponent output="false" hint="I am a Model-Glue controller." beans="Users" extends="ModelGlue.gesture.controller.Controller">

	<cffunction name="init" access="public" output="false" hint="Constructor">
		<cfreturn this />
	</cffunction>


	<cffunction name="users" output="false" hint="I am a message listener function generated for the ""get.users"" event.">
		<cfargument name="event" />

		<cfset event.setValue("users",beans.Users.getUsers())/>
		
		<!--- 
			Put "behind the scenes" query, form validation, and model interaction code here.
			  
			Use event.getValue("name") to get variables from the FORM and URL scopes.
		--->
	</cffunction>
	

</cfcomponent>
	
