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
var gbInited=false;
var gWndStubPage=null;
function getStubPage()
{
	if(!gbInited)
	{
		gWndStubPage=getStubPage_inter(window);
		gbInited=true;
	}
	return gWndStubPage;
}

function getStubPage_inter(wCurrent)
{
	if(null==wCurrent.parent||wCurrent.parent==wCurrent)
		return null;

	if(typeof(wCurrent.parent.whname)=="string"&&"wh_stub"==wCurrent.parent.whname)
		return wCurrent.parent;
	else
		if(wCurrent.parent.frames.length!=0&&wCurrent.parent!=wCurrent)
			return getStubPage_inter(wCurrent.parent);
		else
			return null;
}

function RegisterListener(framename,nMessageId)
{
	var wSP=getStubPage();
	if(wSP&&wSP!=this)
		return wSP.RegisterListener(framename,nMessageId);
	else
		return false;
}

function RegisterListener2(oframe,nMessageId)
{
	var wSP=getStubPage();
	if(wSP&&wSP!=this)
		return wSP.RegisterListener2(oframe,nMessageId);
	else
		return false;
}

function UnRegisterListener2(oframe,nMessageId)
{
	var wSP=getStubPage();
	if(wSP&&wSP!=this&&wSP.UnRegisterListener2)
		return wSP.UnRegisterListener2(oframe,nMessageId);
	else
		return false;
}

function SendMessage(oMessage)
{
	var wSP=getStubPage();
	if(wSP&&wSP!=this&&wSP.SendMessage)
		return wSP.SendMessage(oMessage);
	else
		return false;
}

var gbWhProxy=true;

var gbPreview=false;
gbPreview=false; 
if (gbPreview)
	document.oncontextmenu=contextMenu;

function contextMenu()
{
	return false;
}
