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
var gaFileTopicMapping = new Array();

function fileMapping(sStartKey, sEndKey, sFileName)
{
	this.sStartKey = sStartKey;
	this.sEndKey = sEndKey;
	this.sFileName = sFileName;
	this.aFtsKeys = null;
}

function fileTopicMapping(nIdBegin, nIdEnd, sFileName)
{
	this.nBegin = nIdBegin;
	this.nEnd = nIdEnd;
	this.sFileName = sFileName;
	this.aTopics = null;
}


function iWM(sStartKey, sEndKey, sFileName)
{
	gaFileMapping[gaFileMapping.length] = new fileMapping(sStartKey, sEndKey, sFileName);	
}

function window_OnLoad()
{
	if (parent && parent != this && parent.ftsReady)
	{
		parent.ftsReady(gaFileMapping, gaFileTopicMapping);
	}		
}

function iTM(nIdBegin, nIdEnd, sFileName)
{
	gaFileTopicMapping[gaFileTopicMapping.length] = new fileTopicMapping(nIdBegin, nIdEnd, sFileName);	
}

window.onload = window_OnLoad;
