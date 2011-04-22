%addpath /usr/cluster/software/ccbi/neurosemantics/kkchang/src;
%init;

expt.classifier = 'logisticRegression';

% -----------------------
% Data

%AF3, FC6, FC5, F4

classes = {'baseline', 'hammer', 'house'};

s = 1;
files = dir('data/csv/*.csv');
for f = 1:length(files),
    str = files(f).name;

    [subj str] = strtok(str, '-');
    [cond str] = strtok(str, '-'); cond = find(strcmp(classes, cond));
    [t str] = strtok(str, '-');    t = str2num(t);

    [COUNTER, INTERPOLATED, AF3, F7, F3, FC5, T7, P7, O1, O2, P8, T8, FC6, F4, F8, AF4, RAW_CQ, CQ_AF3, CQ_F7, CQ_F3, CQ_FC5, CQ_T7, CQ_P7, CQ_O1, CQ_O2, CQ_P8, CQ_T8, CQ_FC6, CQ_F4, CQ_F8, CQ_AF4, CQ_CMS, CQ_DRL, GYROX, GYROY, MARKER] = textread(sprintf('data/csv/%s', files(f).name), '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'headerlines', 1, 'delimiter', ',');

    M(f,:) = [mean([AF3, F7, F3, FC5, T7, P7, O1, O2, P8, T8, FC6, F4, F8, AF4]), s, cond, t];
end

X_mask = 1:size(M,2) - 3;
Y_subject = size(M,2) - 2;
Y_exemplar = size(M,2) - 1;
Y_trial = size(M,2);

% -----------------------
% Classification

for t = 1:6,
	test = M(:,Y_trial) == t;
	train = ~test;

	%score = repl2(M(train,Y_exemplar), M(train,X_mask)); [Y I] = sort(score, 'descend'); selected = I(1:2);
	%score = var(M(train, X_mask));                       [Y I] = sort(score, 'descend'); selected = I(1:2);
	selected = [1 11];
	%selected = 1:size(X_mask,2);
	%selected = [1 11 4 12];

	classifier = trainClassifier(zscore(M(train,X_mask(selected))), M(train,Y_exemplar), expt.classifier);

	scores = applyClassifier(zscore(M(test,X_mask(selected))), classifier);
	[acc racc eY] = classifier_score(M(test,Y_exemplar), scores);

	accs(s,t) = mean(acc);
	raccs(s,t) = mean(racc);

end % t

[mean(accs,2) mean(raccs,2)]
