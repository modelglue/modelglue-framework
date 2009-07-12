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
var gaFileMapping = new Array();
function fileMapping(sBK, sEK, sFileName, nNum)
{
	this.sBK = sBK;
	this.sEK = sEK;
	this.sFileName = sFileName;
	this.aKs = null;
	this.nNum = nNum;
	this.oUsedItems = null;
}


function iFM(sBK, sEK, sFileName, nNum)
{
	var i = gaFileMapping.length;
	gaFileMapping[i] = new fileMapping(sBK, sEK, sFileName, nNum);	
	if (i == 0) {
		gaFileMapping[i].nTotal = nNum;
	}
	else {
		gaFileMapping[i].nTotal = nNum + gaFileMapping[i - 1].nTotal;
	}
}

function window_OnLoad()
{
	if (parent && parent != this && parent.projReady)
	{
		parent.projReady(gaFileMapping);
	}		
}

window.onload = window_OnLoad;
