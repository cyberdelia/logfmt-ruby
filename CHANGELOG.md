# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/).

## \[Unreleased\]

## [0.0.10] 2022-04-30
### Changed
  - Autoload the `Logfmt::Parser` when it's used, in preparation for the coming `Logfmt::Logger` and friends.
    Alternatively you can eager-load it into memory: `require "logfmt/parser"`.

### Added
  - This CHANGELOG file.
