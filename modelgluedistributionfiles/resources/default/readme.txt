Model-Glue

This is @versionLabel@ (@versionNumber@).

Well, now you've gone and done it.  

You're probably thinking "Ok, I've downloaded it, what next?"

As the good book says:  "Don't Panic"

** URLS TO KNOW ** 

http://www.model-glue.com - The official Model-Glue web site.
http://www.nodans.com/blog - Dan's blog, where he'll often talk about Model-Glue
http://groups.google.com/group/Model-Glue - The official Model-Glue Google Group
http://svn.model-glue.com - The Subversion repository where you can get the latest Model-Glue code.
http://docs.model-glue.com/wiki - The Model-Glue Wiki, where you can find training materials and reference documentation

** FULL DOCUMENTATION **

Check the Model-Glue Wiki. Documentation is pretty well defined, though if you see areas for improvement, let us know.  

** QUICK INSTALLATION INSTRUCTIONS **

If you're impatient, this should get you started:

1. Download and install ColdSpring from http://www.coldspringframework.org.  

You may need to point a mapping named /coldspring to the directory that *contains* a folder named "beans".

2. Copy the ModelGlue (inside the same directory as this file) folder to whatever ColdFusion sees as "/ModelGlue".  The framework is now installed.  

You may need to point a mapping named /ModelGlue to the directory (/ModelGlue) that contains a folder named "gesture".

3. Copy the modelgluesamples folder to /modelgluesamples.  The samples are now installed.

4. Run some samples - try http://[host]/modelgluesamples/helloworld or http://[host]/modelgluesamples/richwidgets.

5. If you want to use Reactor or Transfer to do scaffolding and automatic database integration, see the instructions in the application template's ColdSpring.xml file for configuring your ORM of choice.  Then, check out "How to Use Generic Database Messages" and "How to Use Scaffolds" under the How To's section of the documentation.

** WHEN THINGS BREAK **

Please add the bug to http://trac.model-glue.com/ and we'll get right on it. Bug Reports are appreciated, Test Cases are even better and patches are Golden.

Please post:

1.  Exactly what you did
2.  What happened (include exceptions, stack traces, sample code, etc.!)
3.  What you thought should have happened

** LICENSE INFORMATION **

Until Thursday, January 4, 2007, Model-Glue was released under for Lesser GPL (LGPL).

In order to maintain clean licensure of generated code, it has been moved to the 
Apache Software License 2.0 (ASL2).

Use of any third party frameworks, such as ColdSpring, Transfer, or Reactor falls
under the respective framework's license.

