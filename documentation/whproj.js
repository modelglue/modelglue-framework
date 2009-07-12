<!---
LICENSE INFORMATION:

Copyright 2007, Joe Rinehart
 
Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. 

You may obtain a copy of the License at 

	http://www.apache.org/licenses/LICENSE-2.0 
	
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.

VERSION INFORMATION:

This file is part of Model-Glue Model-Glue: ColdFusion (2.0.304).

The version number in parenthesis is in the format versionNumber.subversion.revisionNumber.
--->


//	WebHelp 5.10.001
var gaProj=new Array();

gaProj[0]=new project("");

function setLangId(sLangId)
{
	gaProj[0].sLangId=sLangId;
}

function setDataPath(sPath)
{
	if(sPath.length!=0)
	{
		if(sPath.lastIndexOf("/")!=sPath.length-1)
			sPath+="/";
		gaProj[0].sDPath=sPath;	
	}
	else
		gaProj[0].sDPath="";
}

function addToc(sFile)
{
	gaProj[0].sToc=sFile;
}

function addIdx(sFile)
{
	gaProj[0].sIdx=sFile;
}

function addFts(sFile)
{
	gaProj[0].sFts=sFile;
}

function addGlo(sFile)
{
	gaProj[0].sGlo=sFile;
}

function addRemoteProject(sProjRelPath)
{
	if(sProjRelPath.lastIndexOf("/")!=sProjRelPath.length-1)
		sProjRelPath+="/";
	gaProj[gaProj.length]=new project(sProjRelPath);
}

function project(sPPath)
{
	this.sPPath=sPPath;
	this.sLangId="";
	this.sDPath="";
	this.sToc="";
	this.sIdx="";
	this.sFts="";
	this.sGlo="";
}

window.onload=window_OnLoad;

function window_OnLoad()
{
	gsName=document.location.href;
	gsName=_replaceSlash(gsName);
	var nPos=gsName.lastIndexOf("/");
	if(nPos!=-1)
		gaProj[0].sPPath=gsName.substring(0,nPos+1);
	else
		alert("Error in Loading navigation component. Please regenerate WebHelp.");
	patchPath(gaProj);
	if(parent&&parent!=this&& typeof(parent.putProjectInfo)=="function")
	{
		parent.putProjectInfo(gaProj);
	}
}

function patchPath(aProj)
{
	for(var i=1;i<aProj.length;i++)
	{
		aProj[i].sPPath=_getFullPath(gaProj[0].sPPath,aProj[i].sPPath);
	}
}