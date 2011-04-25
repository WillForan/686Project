#!/usr/bin/env bash
#
# Outline of whats going on

ARFF=./total.arff

#WEKA
if true; then					#new baseline
    OUTDIR=results/
    mkdir -p $OUTDIR
#    LEARNERS="classifiers.bayes.NaiveBayes
#    classifiers.trees.J48
#    classifiers.rules.JRip"
#    #classifiers.functions.SMO
#    #clusterers.EM" 
    
    #numeric learners
    LEARNERS=" classifiers.trees.M5P
    classifiers.functions.SMOreg
    classifiers.rules.M5Rules
    clusterers.EM" 

    #do weka
    for LEARNER in $LEARNERS; do 
    	echo $LEARNER; 
	java -Djava.awt.headless=true -classpath /usr/share/java/weka/weka.jar weka.$LEARNER  -t $ARFF -d $OUTDIR/$LEARNER.model > $OUTDIR/$LEARNER.txt
    done;
    #use -l to recall a model, c is which attr to use as class, -d saves model

    #java -classpath /usr/share/java/weka/weka.jar weka.classifiers.meta.Vote -S 1 -B "weka.classifiers.rules.JRip -F 3 -N 2.0 -O 2 -S 1" -B "weka.classifiers.bayes.NaiveBayes " -R MAX
fi

if false; then
    #change pruning(.05 to .5) and min number (1 to 2)
    java -Djava.awt.headless=true -classpath /usr/share/java/weka/weka.jar  weka.classifiers.meta.CVParameterSelection -t $ARFF -P "C .05 .5 5" -P "M 1 2 2" -X 10 -S 1 -W weka.classifiers.trees.J48 --

    java -classpath /usr/share/java/weka/weka.jar weka.experiment.Experiment -l weka.exp.xml -r -D -O
fi


if false; then
#finally done
#java -classpath /usr/share/java/weka/weka.jar weka.classifiers.meta.Vote -S 1 -B "weka.classifiers.rules.JRip -F 3 -N 2.0 -O 2 -S 1" -B "weka.classifiers.bayes.NaiveBayes " -R MAX
java -classpath /usr/share/java/weka/weka.jar weka.classifiers.meta.Vote -l final_model_bayes+rule.model -T final.arff |tee final_output.txt
fi
