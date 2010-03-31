<cfcomponent output="false">

	<!--- define the application --->
	<cfscript>
		this.name = "cfUniForm_Demo_" & reReplace(getCurrentTemplatePath(), "[\W]", "", "all"); // name the application
		this.applicationTimeout = createTimeSpan(2,0,0,0); // timeout application vars in 2 days
		this.clientManagement = false;
		this.sessionManagement = false;
	</cfscript>

	<!--- BEGIN onApplicationStart() method --->
	<cffunction name="onApplicationStart" hint="Initiates the application" returntype="boolean" access="private" output="false">
		<cfscript>
			return true;
		</cfscript>
	</cffunction>
	<!--- END onApplicationStart() method --->
</cfcomponent>
