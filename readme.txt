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

--------------------------------------------------
05-add-fig-numbers

Here is where we need to have @id's on the figs (and tables in the future), so they can be matched to the figs (and tables) with the same idea that were numbered and now live in a separate file. The figs there will overwrite these, adding chapNum and figNum. 

The @id's need to be added before the "add-identifiers" target that id's everything else. 

I could overwrite a preprocessing target, but that could be confusing to maintain. 

Try these two ideas:
1. Move the add-identifiers target to an earlier place in the build. Does this cause problems?
2. Add a target and preprocessing step to add @id's on enumerable elements in the jdw.preprocess for topics. 
    A near-duplicate of "add-topic-numbers" could be done between that target and "topic-chunk". 
3. Requirements/dependencies/workflow to number items by chaper/appendix; three new targets:
    a.  Copy all enumerables to their own files, separated by chapter or appendix. 
	b. Number those.
	c. Apply templates to those enumerables, adding the new chapNum and figNum attributes. 

Earlier, I thought, if you can store the figs in a temporary file, why not just store the meta data you want. Then it occurred to me that, if you can put the figs into a file, you could put them into a variable, similar to the variable $fulltoc that stores the table of contents for the topic numbering. 

So that in memory, each chapter of fig has a tree, each node of which contains the chapter number, fig number, and @id of the figure it belongs to. Then, when applying templates to those figures during preprocessing, that metadata is swept into the fig, just as the topic numbers are. 

