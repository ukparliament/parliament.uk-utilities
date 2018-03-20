FROM ruby:2.5.0-alpine3.7

# Add command line argument variables used to cusomise the image at build-time.
ARG IMAGE_SERVICE_URL
ARG PARLIAMENT_BASE_URL
ARG PARLIAMENT_AUTH_TOKEN
ARG OPENSEARCH_DESCRIPTION_URL
ARG OPENSEARCH_AUTH_TOKEN
ARG AIRBRAKE_PROJECT_ID
ARG AIRBRAKE_PROJECT_KEY
ARG BANDIERA_URL
ARG GTM_KEY
ARG ASSET_LOCATION_URL
ARG SECRET_KEY_BASE
ARG RAILS_LOG_TO_STDOUT
ARG RACK_ENV=production

# Add Gemfiles.
ADD Gemfile /app/
ADD Gemfile.lock /app/

# Set the working DIR.
WORKDIR /app

# Install system and application dependencies.
RUN echo "Environment (RACK_ENV): $RACK_ENV" && \
    apk --update add libcurl && \
    apk --update add --virtual build-dependencies build-base ruby-dev && \
    gem install bundler --no-ri --no-rdoc && \
    if [ "$RACK_ENV" == "production" ]; then \
      bundle install --without development test --path vendor/bundle; \
      apk del build-dependencies; \
    else \
      bundle install --path vendor/bundle; \
    fi

# Copy the application onto our image.
ADD . /app

# Make sure our user owns the application directory.
RUN if [ "$RACK_ENV" == "production" ]; then \
      chown -R nobody:nogroup /app; \
    else \
      chown -R nobody:nogroup /app /usr/local/bundle; \
    fi

# Set up our user and environment
USER nobody
ENV IMAGE_SERVICE_URL $IMAGE_SERVICE_URL
ENV PARLIAMENT_BASE_URL $PARLIAMENT_BASE_URL
ENV PARLIAMENT_AUTH_TOKEN $PARLIAMENT_AUTH_TOKEN
ENV OPENSEARCH_DESCRIPTION_URL $OPENSEARCH_DESCRIPTION_URL
ENV OPENSEARCH_AUTH_TOKEN $OPENSEARCH_AUTH_TOKEN
ENV AIRBRAKE_PROJECT_ID $AIRBRAKE_PROJECT_ID
ENV AIRBRAKE_PROJECT_KEY $AIRBRAKE_PROJECT_KEY
ENV BANDIERA_URL $BANDIERA_URL
ENV GTM_KEY $GTM_KEY
ENV ASSET_LOCATION_URL $ASSET_LOCATION_URL
ENV SECRET_KEY_BASE $SECRET_KEY_BASE
ENV RAILS_LOG_TO_STDOUT $RAILS_LOG_TO_STDOUT
ENV RACK_ENV $RACK_ENV
ENV RAILS_SERVE_STATIC_FILES true

# Precompile assets
RUN rails assets:precompile

# Add additional labels to our image
ARG GIT_SHA=unknown
ARG GIT_TAG=unknown
LABEL git-sha=$GIT_SHA \
	    git-tag=$GIT_TAG \
	    rack-env=$RACK_ENV \
	    maintainer=mattrayner1@gmail.com

# Expose port 3000
EXPOSE 3000

# Launch puma
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
