<cfcomponent output="false" hint="I am an example bean that could represent Tartan settings.">
  <cffunction name="Init" access="public" output="false" hint="I build a new TartanConfiguration bean.">
    <cfset variables.config = "" />
    <cfset variables.type = "" />
    <cfreturn this />
  </cffunction>
  
  <cffunction name="SetConfig" access="public" return="void" output="false" hint="Set property: Config">
    <cfargument name="value" />
    <cfset variables.Config=arguments.value />
  </cffunction>
  
  <cffunction name="GetConfig" access="public" return="string" output="false" hint="Get property: Config">
    <cfreturn variables.Config />
  </cffunction>
  
  <cffunction name="SetType" access="public" return="void" output="false" hint="Set property: Type">
    <cfargument name="value" />
    <cfset variables.Type=arguments.value />
  </cffunction>
  
  <cffunction name="GetType" access="public" return="string" output="false" hint="Get property: Type">
    <cfreturn variables.Type />
  </cffunction>
</cfcomponent>