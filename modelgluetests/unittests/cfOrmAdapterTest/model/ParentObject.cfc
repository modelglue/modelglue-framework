/*
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
*/


component persistent="true" hint="An object to act as a parent to test inheritance." output="false"
{
	property name="mainId" fieldtype="id" generator="native";
	property name="aParentProperty";
	
	property name="parentmany2one" fieldtype="many-to-one" cfc="many2one" fkcolumn="parentmany2oneId";
	property name="parentone2many_array" fieldtype="one-to-many" cfc="parentone2many_array" fkcolumn="mainId" type="array" inverse="true";
	property name="parentone2one" fieldtype="one-to-one" cfc="parentone2one";
	property name="parentmany2many_array" fieldtype="many-to-many" cfc="parentmany2many_array" linktable="parentmain_many2many_array" type="array" inverse="true" fkcolumn="mainId";
	
}
