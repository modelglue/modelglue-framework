<cfcomponent output="false" hint="I perform ColdSpring-specific injection and autowiring functions.">

<!--- PUBLIC --->
<cffunction name="setBeanFactory" access="public" returntype="void" hint="Bean-factory-aware implementation.">
	<cfargument name="beanFactory" type="coldspring.beans.BeanFactory" />
	<cfset variables._beanFactory = arguments.beanFactory />
</cffunction>

<cffunction name="hasInjectionHooks" access="public" returntype="boolean" hint="States if injection hooks are created in the target instance.">
	<cfargument name="target" />

	<cfreturn structKeyExists(arguments.target, "_modelGlueBeanInjection_getVariablesScope")	/>
</cffunction>

<cffunction name="createInjectionHooks" access="public" returntype="void" hint="Creates ""injection hook"" functions in the target object, which are functions that allow access to its variables scope.">
	<cfargument name="target" />
	
	<cfif not hasInjectionHooks(arguments.target)>
		<cfset copyFunctionToTarget(arguments.target, getVariablesScope, "_modelGlueBeanInjection_") />
	</cfif>
</cffunction>

<cffunction name="injectBeanByMetadata" access="public" returntype="void" hint="Injects a given bean with any beans listed in the ""beans"" attribute on its <cfcomponent> tag.">
	<cfargument name="target" type="any" hint="Target for injection." />
	
	<cfset var md = getMetadata(arguments.target) />
	<cfset var beanId = "" />

	<cfif structKeyExists(md, "beans")>
		<cfloop list="#md.beans#" index="beanId">
			<cfset injectBean(trim(beanId), arguments.target) />
		</cfloop>
	</cfif>
</cffunction>

<cffunction name="injectBean" access="public" returntype="void" hint="Injects a given bean into the variables.beans structure in the target.">
	<cfargument name="beanId" type="string" hint="Id of bean to inject" />
	<cfargument name="target" type="any" hint="Target for injection.  If injection hooks don't yet exist, they'll be created." />
	
	<cfset var bean = variables._beanFactory.getBean(beanId) />
	<cfset var beanVariablesScope = "" />
	
	<cfif not hasInjectionHooks(arguments.target)>
		<cfset createInjectionHooks(arguments.target) />
	</cfif>
	
	<cfset beanVariablesScope = arguments.target._modelGlueBeanInjection_getVariablesScope() />
	
	<cfif not structKeyExists(beanVariablesScope, "beans") or not isStruct(beanVariablesScope.beans)>
		<cfset beanVariablesScope.beans = structNew() />
	</cfif>
	
	<cfset beanVariablesScope.beans[replaceNoCase(arguments.beanId, ".", "", "all")] = bean />
</cffunction>

<cffunction name="autowire" access="public" returntype="void" hint="Autowires a CFC based on setter methods.">
	<cfargument name="target" type="any" hint="Instance to autowire." />
	
	<cfset var methodName = "" />
	<cfset var bean = "" />
	
	<!--- TMP --->
	<cfset var name = getMetadata(target).name />
	
	<cfloop collection="#arguments.target#" item="methodName">
		<cfif left(methodName, 3) eq "set" and variables._beanFactory.containsBean(right(methodName, len(methodName) - 3))>
			<cfset bean = variables._beanFactory.getBean(right(methodName, len(methodName) - 3)) />
			<!--- Eval is used to allow varying setter argument names.  Performance != issue for MG, this is a startup item, not runtime. --->
			<cfset evaluate("arguments.target.#methodName#(bean)") />
		</cfif>
	</cfloop>
</cffunction>

<!--- PRIVATE --->

<cffunction name="copyFunctionToTarget" access="private" returntype="void" hint="Copies a function from a source CFC instance to a target CFC instance.">
	<cfargument name="target" />
	<cfargument name="sourceFunctionReference" hint="Reference to source function." />
	<cfargument name="prefix" default="" type="string" hint="Prefix to add to the source function's name to prevent collision." />
	
	<cfset var targetFunctionName = arguments.prefix & getMetadata(arguments.sourceFunctionReference).name />
	
	<cfset arguments.target[targetFunctionName] = arguments.sourceFunctionReference />
</cffunction>

<!--- INJECTED METHOD TEMPLATES --->
<cffunction name="getVariablesScope" hint="Method template to get a target's variables scope.">
	<cfreturn variables />
</cffunction>

</cfcomponent>