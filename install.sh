#!/bin/bash

# options
#sudo sed -i 's/kr.archive.ubuntu.com/ftp.daum.net/g' /etc/apt/sources.list
#sudo sed -i 's/us.archive.ubuntu.com/ftp.daum.net/g' /etc/apt/sources.list

sudo dpkg --add-architecture i386

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y

sudo apt-get install -y libc6:i386 libncurses5:i386 libstdc++6:i386
sudo apt-get install -y cpanminus
sudo apt-get install -y unzip
sudo apt-get install -y g++
sudo apt-get install -y make

sudo cpanm -n local::lib
sudo cpanm -n DBI
sudo cpanm -n DBD::SQLite
sudo cpanm -n forks
sudo cpanm -n forks::shared
sudo cpanm -n File::Which
sudo cpanm -n Perl::Unsafe::Signals
sudo cpanm -n Bit::Vector
sudo cpanm -n Inline::C
sudo cpanm -n IO::All
sudo cpanm -n IO::Prompt
sudo cpanm -n DBD::Pg
sudo cpanm -n Bio::SeqIO
sudo cpanm -n Text::Soundex
sudo cpanm -n LWP::Simple

sudo apt-get install -y abyss
sudo apt-get install -y bwa
sudo apt-get install -y libsparsehash-dev
sudo apt-get install -y cmake
sudo apt-get install -y bamtools
sudo apt-get install -y bedtools
sudo apt-get install -y samtools
sudo apt-get install -y zlib1g-dev
sudo apt-get install -y automake
sudo apt-get install -y libboost-all-dev
sudo apt-get install -y ncbi-blast+
sudo apt-get install -y cd-hit
sudo apt-get install -y exonerate
sudo apt-get install -y snap

sudo apt-get install -y libpq-dev
sudo apt-get install -y libdbd-pg-perl
sudo apt-get install -y postgresql
sudo apt-get install -y dos2unix

wget http://hgwdev.cse.ucsc.edu/~kent/exe/linux/axtChainNet.zip
#wget http://bioinf.uni-greifswald.de/augustus/binaries/augustus-3.3.tar.gz
#wget http://www.repeatmasker.org/RepeatMasker-open-4-0-7.tar.gz
wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/rmblast/2.2.28/ncbi-rmblastn-2.2.28-x64-linux.tar.gz
wget http://tandem.bu.edu/trf/downloads/trf409.linux64
wget http://yandell.topaz.genetics.utah.edu/maker_downloads/1726/7524/8A1A/D9715052FF2398BC5D70137483B6/maker-2.31.9.tgz

git clone https://github.com/jts/sga.git
git clone https://github.com/kuleshov/nanoscope.git
git clone https://github.com/hyphaltip/thesis.git
git clone https://github.com/yeastgenome/AGAPE.git
git clone https://github.com/adamlabadorf/ucsc_tools.git

mkdir AGAPE/programs

cat annotation_test/tar/a.tar.gz* | tar xvzf -
mv -f cfg_files/* AGAPE/cfg_files
rmdir cfg_files

tar xvzf annotation_test/utils.tar.gz
mv -f utils/* AGAPE/src/utils
cd AGAPE/src/utils
make
cd ../../..
rmdir utils

# sga
mv -f sga AGAPE/programs/sga

# axtChainNet
unzip axtChainNet.zip -d axtChainNet
mv -f axtChainNet AGAPE/programs/axtChainNet

# faSize
mv -f ucsc_tools/executables/faSize AGAPE/programs/axtChainNet

# genemark
tar xvzf annotation_test/gm_et_linux_64.tar.gz
cp gm_et_linux_64/gmes_petap/gm_key ~/.gm_key
mv gm_et_linux_64 AGAPE/programs/gm_et_linux_64

# gmhmmp & gmsn.pl
mv -f nanoscope/sw/src/quast-2.3/libs/genemark/linux_64/gmhmmp AGAPE/programs/gm_et_linux_64/gmes_petap
mv -f nanoscope/sw/src/quast-2.3/libs/genemark/linux_64/gmsn.pl AGAPE/programs/gm_et_linux_64/gmes_petap

# gff2zff.pl
chmod 775 thesis/src/gene_prediction/gff2zff.pl
sudo cp thesis/src/gene_prediction/gff2zff.pl /usr/bin

# rmblast
tar zxvf ncbi-rmblastn-2.2.28-x64-linux.tar.gz
chmod 775 ncbi-rmblastn-2.2.28/bin/rmblastn
sudo cp ncbi-rmblastn-2.2.28/bin/rmblastn /usr/bin

# RepeatMasker
tar xvf RepeatMasker-open-4-0-7.tar
sudo cp -r RepeatMasker /usr/local/RepeatMasker
mv -f RepeatMasker AGAPE/programs/RepeatMasker

# trf
chmod a+x trf409.linux64
sudo ln -s trf409.linux64 /usr/local/RepeatMasker
sudo mv -f trf409.linux64 /usr/local/bin

# augustus
tar xvf augustus-3.3.1.tar
cd augustus
make
cd src
make
cd ../..
mv -f augustus AGAPE/programs/augustus

# maker
tar xvzf maker-2.31.9.tgz
cd maker/src
perl ./Build.PL
./Build installdeps # enter Yes at local installation
./Build install
cd ../..
mv -f maker AGAPE/programs/maker

mv -f annotation_test/configs.cf AGAPE/configs.cf
mv -f annotation_test/maker_exe.ctl AGAPE/cfg_files/maker_exe.ctl
mv -f annotation_test/GeneMark_hmm.mod AGAPE/programs/gm_et_linux_64/gmes_petap/GeneMark_hmm.mod

chmod 775 AGAPE/configs.cf
chmod 775 AGAPE/cfg_files/maker_exe.ctl
chmod 775 AGAPE/programs/gm_et_linux_64/gmes_petap/GeneMark_hmm.mod
chmod 775 AGAPE/cfg_files/*
chmod 775 AGAPE/src/utils/*

dos2unix AGAPE/agape_annot.sh
dos2unix AGAPE/combined_annot.sh
dos2unix AGAPE/final_annot.sh
dos2unix AGAPE/intervals.sh
dos2unix AGAPE/non_ref.sh
dos2unix AGAPE/run_comb_annot.sh

rm -f axtChainNet.zip augustus-3.3.1tar RepeatMasker-open-4-0-7.tar ncbi-rmblastn-2.2.28-x64-linux.tar.gz maker-2.31.9.tgz
rm -rf nanoscope thesis annotation_test ncbi-rmblastn-2.2.28 ucsc_tools
rm -f install.shg
