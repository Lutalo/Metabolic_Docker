FROM centos-updated

WORKDIR /metabolic

ADD . /metabolic

RUN yum groupinstall -y "Development Tools" \
	&& yum install -y \
		git \
		gcc \
		gcc-c++ \
		zlib-devel \
		zlib-static \
		make \
        epel-release \
		wget \
        bzip2-devel \
        xz-devel \
        libcurl-devel \
        perl-core \
        perl-App-cpanminus \
        perl-GD

WORKDIR /builds
RUN wget https://github.com/Kitware/CMake/releases/download/v3.15.4/cmake-3.15.4.tar.gz \
	&& tar -xvf cmake-3.15.4.tar.gz \
	&& cd cmake-3.15.4 \
	&& ./bootstrap \
	&& make \
	&& make install 


WORKDIR /builds
RUN git clone git://github.com/pezmaster31/bamtools.git \
	&& cd bamtools \
	&& mkdir build \
	&& cd build \
	&& cmake -DCMAKE_INSTALL_PREFIX=/builds .. \
	&& make \
	&& make DESTDIR=/../bamtools install

WORKDIR /builds
RUN wget http://eddylab.org/software/hmmer/hmmer.tar.gz \
    && tar xvf hmmer.tar.gz \
    && cd hmmer-3.2.1 \
    && ./configure \
    && make \
    && make install

WORKDIR /builds
RUN git clone https://github.com/hyattpd/Prodigal.git \
    && cd Prodigal \
    && make install

WORKDIR /builds
RUN git clone git://github.com/samtools/htslib.git \
    && git clone git://github.com/samtools/bcftools.git \
    && cd bcftools \
    && make \
    && make install

WORKDIR /builds
RUN wget https://github.com/wwood/CoverM/releases/download/v0.3.0/coverm-x86_64-unknown-linux-musl-0.3.0.tar.gz \
    && tar xvf coverm-x86_64-unknown-linux-musl-0.3.0.tar.gz \
    && cd coverm-x86_64-unknown-linux-musl-0.3.0 \
    && mv coverm /usr/bin/


WORKDIR /builds
RUN cpanm Data::Dumper \
    && cpanm Excel::Writer::XLSX \
    && cpanm Getopt::Long \
    && cpanm Statistics::Descriptive \
    && cpanm Array::Split \
    && cpanm Bio::SeqIO \
    && cpanm Bio::Perl \
    && cpanm Bio::Tools::CodonTable \
    && cpanm Carp

RUN yum install -y epel-release \
    && yum install -y R \
    && mkdir -p /usr/share/doc/R-3.60/html \
    && cp /usr/lib64/R/library/stats/html/R.css /usr/share/doc/R-3.6.0/html/ \
    && Rscript -e 'install.packages("diagram", repos = "http://cran.us.r-project.org")'

WORKDIR /metabolic/METABOLIC
RUN run_to_setup.sh
