<cfcomponent>

	<cffunction name="handleEvent" access="remote">
		<cfset var cspath = "/modelgluetests/unittests/gesture/ColdSpring.xml" />
		<cfset var bootstrapper = createObject("component", "ModelGlue.gesture.loading.ColdSpringBootstrapper")>
		
		<cfset bootstrapper.coldspringPath = cspath>
		<cfset bootstrapper.coreColdspringPath = cspath>
		<cfset bootstrapper.modelGlueBeanName = "modelglue.ModelGlue">
		
		<cfset request._modelglue.bootstrap.bootstrapper = bootstrapper />
		<cfset request._modelglue.bootstrap.initializationRequest = true />
		<cfset request._modelglue.bootstrap.initializationLockPrefix = expandPath(".") & "/.modelglue" />
		<cfset request._modelglue.bootstrap.initializationLockTimeout = 60 />
		
		<cfset mg = bootstrapper.createModelGlue() />
		<cfset request._modelglue.bootstrap.framework = mg />
		
		<cfset var loader = "" />
		<cfset var obj = "" />
		<cfset var beanFactory = "" />
		<cfset var ec ="" />
		<cfset arrayAppend(mg.configuration.assetmappings, "/modelgluetests/unittests/gesture/modules/asset") />
		<cfset arrayAppend(mg.configuration.viewmappings, "/modelgluetests/unittests/gesture/modules/asset") />
		<cfset beanFactory = mg.getInternalBeanFactory() />
		<cfset beanFactory.loadBeans(expandPath("/modelgluetests/unittests/gesture/externaladapters/beaninjection/ColdSpring.xml")) />
		<cfset beanFactory.loadBeans(expandPath("/modelgluetests/unittests/gesture/modules/asset/CS_AssetManagerBeans.xml")) />
		<cfset loader = mg.getInternalBean("modelglue.ModuleLoaderFactory").create("XML") />
		<cfset loader.load(mg, "/modelgluetests/unittests/gesture/modules/asset/EventWithAsset.xml") />		

		<cfset ec = mg.handleRequest() />
		
	</cffunction>

</cfcomponent>