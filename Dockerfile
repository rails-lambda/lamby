FROM lambci/lambda:build-ruby2.7

# Asset Pipeline
RUN curl -sL https://rpm.nodesource.com/setup_12.x | bash - && \
    yum install -y nodejs

WORKDIR /var/task
