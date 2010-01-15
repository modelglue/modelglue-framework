<cfset bootstrapper = createObject("component", "ModelGlue.gesture.loading.ColdSpringBootstrapper")>
<cfset bootstrapper.coldspringPath = "/ModelGlue/gesture/test/ColdSpring.xml" />
<cfset bootstrapper.coreColdspringPath = "/ModelGlue/gesture/test/ColdSpring.xml" />

<cfset request._modelglue.bootstrap.bootstrapper = bootstrapper />
<cfset request._modelglue.bootstrap.initializationRequest = true />
<cfset mg = bootstrapper.createModelGlue() />
<!--- load "test" application event definitions --->
<cfset mg.getInternalBean("modelglue.ModuleLoaderFactory").create("XML").load( mg, expandPath("/ModelGlue/gesture/test/primaryModule.xml") ) />


<cfparam name="url.someValue" default="" />

<cfset ec = mg.getEventContextFactory().new() />

<cfset ec.setValue("someValue", url.someValue) />

<cfset ec.forwardToUrl(url.url, true, false) />
