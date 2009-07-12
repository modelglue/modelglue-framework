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
var gWEA = new Array();
function aWE()
{
	var len = gWEA.length;
	gWEA[len] = new ftsEntry(aWE.arguments);
}

function ftsEntry(fn_arguments) 
{
	if (fn_arguments.length && fn_arguments.length >= 1) 
	{
		this.sItemName = fn_arguments[0];
		this.aTopics = null;
		var nLen = fn_arguments.length;
		if (nLen > 1) 
		{
			this.aTopics = new Array();
			for (var i = 0; i < nLen - 1; i ++ )
			{
				this.aTopics[i] = fn_arguments[i + 1];
			}
		}
	}
}

function window_OnLoad()
{
	if (parent && parent != this) {
		if (parent.putFtsWData) 
		{
			parent.putFtsWData(gWEA);
		}
	}
}

window.onload = window_OnLoad;