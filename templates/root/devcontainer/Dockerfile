# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.3.4
FROM ghcr.io/rails/devcontainer/images/ruby:$RUBY_VERSION

# Install Node.js
RUN apt-get update -qq && apt-get install -y nodejs npm

# Copy the Visual Studio Code Extension
COPY layered-stack-0.0.1.vsix /tmp/
