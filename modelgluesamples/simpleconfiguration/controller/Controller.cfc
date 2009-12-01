<cfcomponent 
  output="false" 
  extends="ModelGlue.gesture.controller.Controller"
  beans="modelglue.applicationConfiguration"
>

	<cffunction name="init" access="public" output="false" hint="Constructor">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="loadConfiguration" output="false" hint="Sets configuration values into the event.">
		<cfargument name="event" />
		
		<cfset event.setValue("datasourceName", beans.modelglueApplicationConfiguration.getConfigSetting("myDatasource")) />
		<cfset event.setValue("dateFormat", beans.modelglueApplicationConfiguration.getConfigSetting("dateFormat")) />
	</cffunction>
							
				

</cfcomponent>
	
