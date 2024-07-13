What the hell are these folders supposed to be? 00-simple? 03-add-numbers-to-titles?

Well, calm down. It makes perfect sense. To me. Right now. It may not in the future, so this is a remind-me as much as a readme.

To deconstruct (yes, I hate that word, too, but it's better than "decompose" which is what we do after we die) the process that a real OT developer would just do, so as to better understand what is going on, I looked at the build process for a transtype that numbers topics for HTML. It was originally used on the DITA Specification; see the numbered chapters and appendixes. 

The task at hand is to number elements inside the topics. And the only plug-in that does that and is available publicly only works on obsolete editions of the OT. Instead of begging the guy to update, which he said he would do if enough people were interested, I figured I would build my own. That was sometime last year, I think.

Currently, the best place for the new number-figures target seems to be after numbering the titles. This would have the advantage of being similar, maybe reusing bits of code, and leveraging the way the metadata is processed--what works for chapters and topics and titles should work for figures and tables. 
--------------------------------------------------
00-simple
This is the utility player. Add or remove targets from topic-chunk to add-numbers-to-titles, to see the output for a given target. 

00-simple/temp/[hash number].ditamap becomes whatever you need at any given time. You need to see the output of add-numbers-to-titles? Make sure the target and it dependencies are not commented out, run the tx and get the temp files. 
one directory to another. 
--------------------------------------------------
01-number-topics/01-number-topics.ditamap (no need to rename the topics; it would serve no purpose)

Copy the files from the topic-chunk target in 00-simple/temp and use those for input. Number the topics. 

--------------------------------------------------
02-number-figures/01-number-figures.ditamap 

Copy the files from the number-topics target in 00-simple/temp and use those for input. Number the figures.

This is the point of this whole repo. 

--------------------------------------------------
03-add-numbers-to-titles/03-add-numbers-to-titles.ditamap 

Copy the files from the number-figures target in 00-simple/temp and use those for input. 

Add the numbers to the beginning of the chapter titles. 
