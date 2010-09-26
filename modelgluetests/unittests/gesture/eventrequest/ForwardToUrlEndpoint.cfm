<cfset bootstrapper = createObject("component", "ModelGlue.gesture.loading.ColdSpringBootstrapper")>
<cfset bootstrapper.coldspringPath = "/modelgluetests/unittests/gesture/ColdSpring.xml" />
<cfset bootstrapper.coreColdspringPath = "/modelgluetests/unittests/gesture/ColdSpring.xml" />

<cfset request._modelglue.bootstrap.bootstrapper = bootstrapper />
<cfset request._modelglue.bootstrap.initializationRequest = true />
<cfset mg = bootstrapper.createModelGlue() />
<!--- load "test" application event definitions --->
<cfset mg.getInternalBean("modelglue.ModuleLoaderFactory").create("XML").load( mg, expandPath("/modelgluetests/unittests/gesture/primaryModule.xml") ) />


<cfparam name="url.someValue" default="" />

<cfset ec = mg.getEventContextFactory().new() />

<cfset ec.setValue("someValue", url.someValue) />

<cfset ec.forwardToUrl(url.url, true, false) />
