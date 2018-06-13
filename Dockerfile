FROM fpco/stack-build
RUN apt-get update && apt-get install -y --no-install-recommends \
      curl \
      git \
      python-dev \
      python-pip \
      zlib1g-dev \
 && pip install awscli \
