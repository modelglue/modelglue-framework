<cfsilent>
<cfparam name="ModelGlue_APP_KEY" default="_modelglue" />
<cfparam name="ModelGlue_CONFIG_PATH" default="" />
<cfparam name="ModelGlue_LOCAL_COLDSPRING_PATH" default="./config/ColdSpring.xml" />
<cfparam name="ModelGlue_CORE_COLDSPRING_PATH" default="/ModelGlue/gesture/configuration/ModelGlueConfiguration.xml" />
<cfparam name="ModelGlue_PARENT_BEAN_FACTORY" default="" />
<cfparam name="ModelGlue_PARENT_BEAN_FACTORY" default="" />
<cfparam name="ModelGlue_LOCAL_COLDSPRING_DEFAULT_ATTRIBUTES" default="#structNew()#" />
<cfparam name="ModelGlue_LOCAL_COLDSPRING_DEFAULT_PROPERTIES" default="#structNew()#" />
<cfparam name="ModelGlue_VERSION_INDICATOR" default="GESTURE" />
<cfparam name="ModelGlue_INITIALIZATION_LOCK_TIMEOUT" default="60" />
<cfparam name="request._modelglue.bootstrap" default="#structNew()#" />
<cfparam name="request._modelglue.bootstrap.blockEvent" default="0" />

<cfset request._modelglue.bootstrap.initializationRequest = false />
<cfset request._modelglue.bootstrap.appKey = ModelGlue_APP_KEY />
<cfset request._modelglue.bootstrap.initializationLockPrefix = expandPath(".") & "/.modelglue" />
<cfset request._modelglue.bootstrap.initializationLockTimeout = ModelGlue_INITIALIZATION_LOCK_TIMEOUT />

<cfif not structKeyExists(application, ModelGlue_APP_KEY) 
			or (
					structKeyExists(url, application[ModelGlue_APP_KEY].configuration.reloadKey)
					and url[application[ModelGlue_APP_KEY].configuration.reloadKey] eq application[ModelGlue_APP_KEY].configuration.reloadPassword
			)
			or (
					application[ModelGlue_APP_KEY].configuration.reload
			)>
	<cflock name="#request._modelglue.bootstrap.initializationLockPrefix#.loading" type="exclusive" timeout="#request._modelglue.bootstrap.initializationLockTimeout#">
		<cfif not structKeyExists(application, ModelGlue_APP_KEY)
					or (
							structKeyExists(url, application[ModelGlue_APP_KEY].configuration.reloadKey)
							and url[application[ModelGlue_APP_KEY].configuration.reloadKey] eq application[ModelGlue_APP_KEY].configuration.reloadPassword
					)
					or (
							application[ModelGlue_APP_KEY].configuration.reload
					)>
			<cfset request._modelglue.bootstrap.initializationRequest = true />

			<cfset boot = createObject("component", "ModelGlue.gesture.loading.ColdSpringBootstrapper") />

			<cfset boot.applicationKey = ModelGlue_APP_KEY />
			<cfset boot.coldspringPath = ModelGlue_LOCAL_COLDSPRING_PATH />
			<cfset boot.defaultColdSpringAttributes = ModelGlue_LOCAL_COLDSPRING_DEFAULT_ATTRIBUTES />
			<cfset boot.defaultColdSpringProperties = ModelGlue_LOCAL_COLDSPRING_DEFAULT_PROPERTIES />
			<cfset boot.coreColdspringPath = ModelGlue_CORE_COLDSPRING_PATH />
			<cfset boot.modelglueVersionIndicator = ModelGlue_VERSION_INDICATOR />
			<cfset boot.primaryModulePath = ModelGlue_CONFIG_PATH />
			<cfset boot.parentBeanFactory = ModelGlue_PARENT_BEAN_FACTORY />

			<cfset mg = boot.storeModelGlue() />
		<cfelse>
			<cfset mg = application[ModelGlue_APP_KEY] />
		</cfif>
	</cflock>
<cfelse>
	<cfset mg = application[ModelGlue_APP_KEY] />
</cfif>


<cfif not request._modelglue.bootstrap.blockEvent>
	<cfset ec = mg.handleRequest() />
</cfif>

</cfsilent><cfif not request._modelglue.bootstrap.blockEvent><cfoutput>#ec.getLastRendereredView()#</cfoutput>

<cfif mg.configuration.debug neq "false" and mg.configuration.debug neq "none"> 
<cfoutput>
	#mg.renderContextLog(ec)#
</cfoutput>
</cfif>
</cfif>
