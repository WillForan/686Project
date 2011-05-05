#!/usr/bin/env bash
#
# Outline of whats going on

ARFF=./arff/total.arff
OUTDIR=results/
mkdir -p $OUTDIR

#WEKA
if true; then					#new baseline
    LEARNERS="classifiers.bayes.NaiveBayes
    classifiers.trees.J48
    classifiers.rules.JRip
    classifiers.meta.AdaBoostM1"
    #classifiers.functions.SMO
    #clusterers.EM" 
    
    #do weka
    for LEARNER in $LEARNERS; do 
    	echo $LEARNER; 
	java -Djava.awt.headless=true -classpath /usr/share/java/weka/weka.jar weka.$LEARNER  -t $ARFF -d $OUTDIR/$LEARNER.model 2>/dev/null |tee $OUTDIR/$LEARNER.txt | grep "Correctly Classified Instances"|tail -n1
    done;
    #use -l to recall a model, c is which attr to use as class, -d saves model

    #java -classpath /usr/share/java/weka/weka.jar weka.classifiers.meta.Vote -S 1 -B "weka.classifiers.rules.JRip -F 3 -N 2.0 -O 2 -S 1" -B "weka.classifiers.bayes.NaiveBayes " -R MAX
fi

if true; then
    #change pruning(.05 to .5) and min number (1 to 2)
    echo "pruning"
    java -Djava.awt.headless=true -classpath /usr/share/java/weka/weka.jar  weka.classifiers.meta.CVParameterSelection -t $ARFF -P "C .05 .5 5" -P "M 1 2 2" -X 10 -S 1 -W weka.classifiers.trees.J48 --  2>/dev/null| tee $OUTDIR/pruning_tree.txt | grep Correct

    #java -classpath /usr/share/java/weka/weka.jar weka.experiment.Experiment -l weka.exp.xml -r -D -O
fi


if true; then
#finally done
echo "vote between jrip and bayes";
java -classpath /usr/share/java/weka/weka.jar weka.classifiers.meta.Vote -S 1 -B "weka.classifiers.rules.JRip -F 3 -N 2.0 -O 2 -S 1" -B "weka.classifiers.bayes.NaiveBayes " -R MAX -t $ARFF 2>/dev/null|tee $OUTDIR/vote-jrip-bays.txt | grep Correct
#java -classpath /usr/share/java/weka/weka.jar weka.classifiers.meta.Vote -l final_model_bayes+rule.model -T final.arff |tee final_output.txt
fi
