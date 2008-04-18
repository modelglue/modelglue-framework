Model-Glue
Joe Rinehart (joe@firemoss.com)
Model-Glue @versionLabel@ (@versionNumber@.@revisionNumber@).

Well, now you've gone and done it.  

You're probably thinking "Ok, I've downloaded it, what next?"

As the good book says:  "Don't Panic"

** URLS TO KNOW ** 

http://www.model-glue.com - The official Model-Glue web site.
http://www.firemoss.com/blog - Joe's blog, where he'll often talk about Model-Glue
http://groups.google.com/group/Model-Glue - The "official" Model-Glue Google Group
http://groups.google.com/group/ModelGlue - The "unofficial" Model-Glue Google Group
http://svn.model-glue.com - The Subversion repository where you can get the latest Model-Glue code.

** FULL DOCUMENTATION **

This is an alpha build.  Documentation is sparse.  It's intended more for seasoned Model-Glue users.

All of the documentation from Model-Glue 2 (http://docs.model-glue.com) is relevant and fairly
accurate, except for the <scaffold /> tag, which simply won't work at all (it's being replaced).

** QUICK INSTALLATION INSTRUCTIONS **

If you're impatient, this should get you started:

1. Download and install ColdSpring from http://www.coldspringframework.org.  

You may need to point a mapping named /coldspring to the directory that *contains* a folder named "beans".

2. Copy the ModelGlue (inside the same directory as this file) folder to whatever ColdFusion sees as "/ModelGlue".  The framework is now installed.  

You may need to point a mapping named /ModelGlue to the directory (/ModelGlue) that contains ModelGlue.cfm.

3. Copy the modelgluesamples folder to /modelgluesamples.  The samples are now installed.

4. Run some samples - try http://[host]/modelgluesamples/legacysamples/nameuppercaser or http://[host]/modelgluesamples/legacysamples/contactmanager.

5. If you want to use Reactor or Transfer to do scaffolding and automatic database integration, see the instructions in the application template's ColdSpring.xml file for configuring your ORM of choice.  Then, check out "How to Use Generic Database Messages" and "How to Use Scaffolds" under the How To's section of the documentation.

** WHEN THINGS BREAK **

For alpha purposes, post a message to the official Model-Glue group (http://groups.google.com/group/Model-Glue).

If you include "Gesture alpha" in the subject, it'll get filtered in Joe's mail rules to a special box.

1.  Exactly what you did
2.  What happened (include exceptions, stack traces, sample code, etc.!)
3.  What you thought should of happened

** LICENSE INFORMATION **

Until Thursday, January 4, 2007, Model-Glue was released under for Lesser GPL (LGPL).

In order to maintain clean licensure of generated code, it has been moved to the 
Apache Software License 2.0 (ASL2).

Use of any third party frameworks, such as ColdSpring, Transfer, or Reactor falls
under the respecitve framework's license.

