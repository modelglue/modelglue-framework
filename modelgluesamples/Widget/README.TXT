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


Widget Central example.

This directory contains the same application implemented with both the Reactor 
and Transfer ORMs.  The /install directory contains a .SQL script to create
the database on MySQL 5.0:  it's only four tables, so changing this to suit
your DB of choice should be fairly straightforward.

The example application itself shows how to scaffold, represent one-to-many,
many-to-one, and many-to-many relationships, as well as use Generic Database
Messages to fire custom gateway methods.

To install:

1.  Create a database and run the install script against it.
2.  Create a datasource named "Widget" pointed to the database
3.  Run either the /reactor or /transfer version of the application.

BETA 2 Warning:

All of the issues with attempting to distribute Reactor and Transfer based
applications that already contain ORM-generated code are not known.  I expect
some of the first people trying this will be posting Trac tickets at 
http://trac.model-glue.com.  Thanks.

Even more thanks if you post the fix to whatever goes wrong ;).

-Joe
