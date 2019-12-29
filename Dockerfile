# Use image built by docker-setup.sh
FROM private/sage-cplex
ARG CPLEX_VERSION=12.10
ADD . /sage-numerical-backends-cplex/
RUN bash -l -c 'conda activate sagecoin; export CPLEX_HOME=/opt/ibm/ILOG/CPLEX_Studio$(echo ${CPLEX_VERSION} | sed -e "s/[.]//g;"); cd sage-numerical-backends-cplex && sage setup.py test && sage -python -m pip install . && ./test_all.sh'
