-----STATUS-------
logisticRegression and nbayes return values

nnet, svmlight, etc break (complian about double/char type)


-----OVERVIEW-----
Perl and bash are used to generate and record a playlist of 15 sec segments.
ffplay is required for the playlist

main.m pulls all MATLAB files together except plotting.

Look at cor_graph.dot (via graphviz e.g. dot -Tx11 cor_graph.dot) for a
directional graph.

Pipeline:
* Aquire sound files
** naming convension: Sense-.... and AntiSense-.....
** Clips ripped from videos of news and tv shows or projectgutenburgh short stories
** random text generators and short stories were passed to festival for text
to speach conversion with female US english speaker.
** split clips into 15second segments
*** generatePlaylist.pl (generates playlist.sh)
*** sh2pls.sh (gerates newline seperated Sense/Antisense label from playlist.sh)
* Record EEG of listner to random sense/antisense segments
* export emotive to csv
* MATLAB (main.m)
** importEmotiveData(csv)
** csCompile(data,labels)
*** directory struture: 
	trial/
	   person_trail1/
	   	*pls	   -- newline del. label for each bin
		*(csv|mat) -- data, if matfile one var struct
				from importEmotiveData named
				'e' or the file name
** csOSTest
*** called with classifiers
	nbayes
	logisticRegression
