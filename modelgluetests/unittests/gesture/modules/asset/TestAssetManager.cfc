<!---
LICENSE INFORMATION:

Copyright 2011, Joe Rinehart, Dan Wilson

Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. 

You may obtain a copy of the License at 

	http://www.apache.org/licenses/LICENSE-2.0 
	
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.

VERSION INFORMATION:

This file is part of @versionLabel@ (@versionNumber@).

The version number in parentheses is in the format versionNumber.subversion.revisionNumber.

If the version number appears as 'versionNumber' surrounded by @ symbols
then this file is a working copy and not part of a release build.
--->


﻿<cfcomponent extends="modelgluetests.unittests.gesture.ModelGlueAbstractTestCase">

<cfset this.coldspringPath = "/modelgluetests/unittests/gesture/ColdSpring.xml">
<!--- regular expressions to match --->
<cfset jsStringWithoutHost = '<script type="text/javascript" src="/modelgluetests/unittests/gesture/modules/asset/blank.js"></script>' />
<cfset cssStringWithoutHost = '<link type="text/css" rel="stylesheet" media="all" href="/modelgluetests/unittests/gesture/modules/asset/blank.css" />' />
<cfset jsStringWithHost = '<script type="text/javascript" src="http://.\.domain\.com/modelgluetests/unittests/gesture/modules/asset/blank\.js"></script>' />
<cfset cssStringWithHost = '<link type="text/css" rel="stylesheet" media="all" href="http://.\.domain\.com/modelgluetests/unittests/gesture/modules/asset/blank\.css" />' />
<cfset assetMissingString = '<!--ERROR: AssetManager could not locate asset missing\.js -->' />

<cffunction name="setup">
	<cfset createModelGlueIfNotDefined() />
</cffunction>

<cffunction name="testAssetRenderedWithoutHost" returntype="void" access="public">
	<cfset mg.assetmanager = mg.getBean('assetManager.withoutHosts') /> 	
	<cfset url.event = "renderAsset" />
	<cfset ec = mg.handleRequest() />
 	<cfset assertTrue(trim(request.assets) EQ trim(jsStringWithoutHost), "could not find regular expression '#htmleditformat(jsStringWithoutHost)#' in #htmleditformat(request.assets)#") />
</cffunction>

<cffunction name="testRenderingMulitpleAssetsWithoutHost">
	<cfset mg.assetmanager = mg.getBean('assetManager.withoutHosts') /> 	
	<cfset url.event = "renderJSandCssAssets" />
	<cfset ec = mg.handleRequest() />
	<cfset pos = refind(jsStringWithoutHost, request.assets) />
 	<cfset assertTrue(pos GT 0, "JS asset not found") />
	<cfset pos = refind(cssStringWithoutHost, request.assets) />
 	<cfset assertTrue(pos GT 0, "CSS asset not found") />
</cffunction>

<cffunction name="testRenderingMulitpleAssetsWithHost">
	<cfset mg.assetmanager = mg.getBean('assetManager.withHosts') /> 	
	<cfset url.event = "renderJSandCssAssets" />
	<cfset ec = mg.handleRequest() />
	<cfset pos = refind(jsStringWithHost, request.assets) />
 	<cfset assertTrue(pos GT 0, "JS asset not found") />
	<cfset pos = refind(cssStringWithHost, request.assets) />
 	<cfset assertTrue(pos GT 0, "CSS asset not found") />
</cffunction>


<cffunction name="testAssetRenderedWithHost" returntype="void" access="public">
	<cfset mg.assetmanager = mg.getBean('assetManager.withHosts') /> 	
	<cfset url.event = "renderAsset" />
	<cfset ec = mg.handleRequest() />
	<cfset pos = refind(jsStringWithHost, request.assets) />
 	<cfset assertTrue(pos GT 0, "could not find regular expression '#htmleditformat(jsStringWithoutHost)#' in '#htmleditformat(request.assets)#'") />
</cffunction>

<cffunction name="testMissingAsset" returntype="void" access="public">
	<cfset var trace = "" />
	<cfset var i = 0 />
	<cfset var msg = "" />
	<cfset mg.assetmanager = mg.getBean('assetManager.withoutHosts') /> 	
	<cfset url.event = "renderMissingAsset" />
	<cfset ec = mg.handleRequest() />
	<cfset pos = refind(assetMissingString, request.assets) />
 	<cfset assertTrue(pos GT 0, "could not find regular expression '#htmleditformat(assetMissingString)#' in #htmleditformat(request.assets)#") />

	<cfset trace = ec.getTrace() />
	<cfloop from="1" to="#arraylen(trace)#" index="i">
		<cfif trace[i].message IS "Could not locate asset ('missing.js')">
			<cfset msg = trace[i] />
		</cfif>
	</cfloop>
	<cfset assertTrue(isStruct(msg), "Missing Asset trace message not found") />
	
</cffunction>

<cffunction name="testAssetRendingWithCFHtmlHeadViaSubRequest" returntype="void" access="public">
	<cfset remote_uri = "http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT#/modelgluetests/unittests/gesture/modules/asset/RunEvent.cfc?method=handleEvent&event=renderAsset" />
	<cfhttp url="#remote_uri#">
	<cfset assertTrue(trim(cfhttp.Filecontent) EQ trim(jsStringWithoutHost), "Expected '#htmleditformat(jsStringWithoutHost)#' but got '#htmleditformat(cfhttp.Filecontent)#'") />
</cffunction>

<cffunction name="createModelGlueIfNotDefined" returntype="any" access="private">
	<cfset super.createModelGlueIfNotDefined(this.coldspringPath) />
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
</cffunction>


</cfcomponent>
