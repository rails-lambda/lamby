FROM public.ecr.aws/lambda/ruby:2.7
ARG RAILS_ENV
ENV RAILS_ENV=$RAILS_ENV

COPY . .

# == Cleanup Unused Files & Directories ==
RUN rm -rf \
    log \
    node_modules \
    test \
    tmp \
    vendor/bundle/ruby/2.7.0/cache

CMD ["app.handler"]
