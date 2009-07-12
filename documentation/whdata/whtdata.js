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
var gTEA = new Array();
function aTE()
{
	gTEA[gTEA.length] = new tocEntry(aTE.arguments);
}

function tocEntry(fn_arguments) 
{
	if (fn_arguments.length < 3)	
	{
		alert ("data format wrong!!!");
		return;
	}
	
	this.nType = fn_arguments[0];
	this.nContents = fn_arguments[1];
	this.sItemName = fn_arguments[2];
	
	if (this.nType == 1 || this.nType == 2 || this.nType == 16)
	{
		if (fn_arguments.length > 3)
		{
			this.sItemURL = fn_arguments[3];
			if (fn_arguments.length > 4)
			{
				this.sTarget = fn_arguments[4];
				if (fn_arguments.length > 5)
					this.sIconRef = fn_arguments[5];
			}
		}
	}
	if (this.nType == 4 || this.nType == 8)
	{
		if (fn_arguments.length > 3)
		{
			this.sRefURL = fn_arguments[3];
			if (this.nType == 4)
			{
				if(this.sRefURL.lastIndexOf("/")!=this.sRefURL.length-1)
					this.sRefURL+="/";
			}
			if (fn_arguments.length > 4)
			{
				this.sItemURL = fn_arguments[4];
				if (fn_arguments.length > 5)
				{
					this.sTarget = fn_arguments[5];
					if (fn_arguments.length > 6)
						this.sIconRef = fn_arguments[6];
				}
			}
		}
	}
}


function window_OnLoad()
{
	if (parent && parent != this && parent.putData) {
		parent.putData(gTEA);
	}
}
window.onload = window_OnLoad;