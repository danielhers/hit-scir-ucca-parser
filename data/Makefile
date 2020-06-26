.PHONY: ewt ewt.mrp ud streusle companion augment split jackknife-ud jackknife-streusle clean

../toolkit/mtool:
	git clone https://github.com/cfmrp/mtool $@ || git submodule init

ewt:
	git clone https://github.com/UniversalConceptualCognitiveAnnotation/UCCA_English-EWT -b master-sentences ewt || cd ewt && git pull

ewt.mrp: ewt ewt.txt
	ls -d ewt/*.pickle | python ../toolkit/mtool/main.py --read ucca --write mrp --text data/ewt.txt > $@
#	wget -qO- http://svn.nlpl.eu/mrp/2019/public/ucca.tgz?p=28375 | tar xvz
#	cp mrp/2019/training/ucca/ewt.mrp ./

ud: en_ewt-ud.conllu en_ewt-ud-train.conllu en_ewt-ud-dev.conllu en_ewt-ud-test.conllu

en_ewt-ud-train.conllu en_ewt-ud-dev.conllu en_ewt-ud-test.conllu:
	git clone https://github.com/UniversalDependencies/UD_English-EWT --branch=r2.5 ud
	cp ud/*.conllu ./

en_ewt-ud.conllu: en_ewt-ud-train.conllu en_ewt-ud-dev.conllu en_ewt-ud-test.conllu
	cat $+ > $@

streusle: streusle.conllulex streusle.ud_train.conllulex streusle.ud_dev.conllulex streusle.ud_test.conllulex

streusle.conllulex streusle.ud_train.conllulex streusle.ud_dev.conllulex streusle.ud_test.conllulex:
	git clone https://github.com/danielhers/streusle --branch=streusle2ucca
	cp streusle/streusle.conllulex streusle/*/streusle.ud_*.conllulex ./

companion: ewt.companion.conllu

ewt.companion.conllu:
	wget -qO- http://svn.nlpl.eu/mrp/2019/public/companion.tgz?p=28375 | tar xvz
	cat mrp/2019/companion/ucca/ewt0*.conllu > $@

augment: ewt.aug.companion.mrp ewt.aug.streusle.mrp

ewt.aug.companion.mrp: ewt.companion.conllu ewt.mrp
	python ../toolkit/augment_data_conllu.py $+ $@

ewt.aug.streusle.mrp: streusle.conllulex ewt.mrp
	python ../toolkit/augment_data_conllulex.py $+ $@

split: ewt ewt/train ewt/dev ewt/test \
       ewt.train.aug.streusle.mrp ewt.dev.aug.streusle.mrp ewt.test.aug.companion.mrp \
       ewt.train.aug.companion.mrp ewt.dev.aug.companion.mrp ewt.test.aug.streusle.mrp

ewt/%: ../file-lists/%.txt
	mkdir -p $@
	xargs -I % find ewt -maxdepth 1 -name '%*.pickle' < $< | xargs ln -srt $@

ewt.%.aug.streusle.mrp: ../file-lists/%.txt ewt.aug.streusle.mrp
	grep -Ff $+ > $@

ewt.%.aug.companion.mrp: ../file-lists/%.txt ewt.aug.companion.mrp
	grep -Ff $+ > $@

jackknife-ud: \
           train-00.conllu train-01.conllu train-02.conllu train-03.conllu train-04.conllu \
           parse-00.ct parse-01.ct parse-02.ct parse-03.ct parse-04.ct \
           test-00.conllu test-01.conllu test-02.conllu test-03.conllu test-04.conllu

train-%.conllu parse-%.ct test-%.conllu: en_ewt-ud-train.conllu ../file-lists/train.txt
	python ../toolkit/jackknife.py $< --doc-ids ../file-lists/train.txt

jackknife-streusle: \
           train-00.conllulex train-01.conllulex train-02.conllulex train-03.conllulex train-04.conllulex \
           parse-00.conllu parse-01.conllu parse-02.conllu parse-03.conllu parse-04.conllu \
           test-00.conllulex test-01.conllulex test-02.conllulex test-03.conllulex test-04.conllulex

clean:
	rm -rf mrp ewt ud streusle *.mrp *.conllu *.conllulex
