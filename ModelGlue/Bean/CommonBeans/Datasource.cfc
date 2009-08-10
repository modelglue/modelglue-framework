<cfcomponent output="false" hint="I am an example bean that could represent datasource settings.">
  <cffunction name="Init" access="public" output="false" hint="I build a new datasource bean.">
    <cfset variables.datasource = "" />
    <cfset variables.username = "" />
    <cfset variables.password = "" />
    <cfreturn this />
  </cffunction>
  
  <cffunction name="SetDSN" access="public" return="void" output="false" hint="Set property: DSN">
    <cfargument name="value" type="string" />
    <cfset variables.datasource=arguments.value />
  </cffunction>
  
  <cffunction name="GetDSN" access="public" return="string" output="false" hint="Get property: DSN">
    <cfreturn variables.datasource />
  </cffunction>
  
  <cffunction name="SetUsername" access="public" return="void" output="false" hint="Set property: Username">
    <cfargument name="value" type="string" />
    <cfset variables.Username=arguments.value />
  </cffunction>
  
  <cffunction name="GetUsername" access="public" return="string" output="false" hint="Get property: Username">
    <cfreturn variables.Username />
  </cffunction>
  
  <cffunction name="SetPassword" access="public" return="void" output="false" hint="Set property: Password">
    <cfargument name="value" type="string" />
    <cfset variables.Password=arguments.value />
  </cffunction>
  
  <cffunction name="GetPassword" access="public" return="string" output="false" hint="Get property: Password">
    <cfreturn variables.Password />
  </cffunction>
  
</cfcomponent>