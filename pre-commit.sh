#!/bin/sh

log_error() {
  echo "$*" 1>&2
}

main() {
  run_gofmt
  run_golint
  run_govet
}

run_gofmt() {
  GOFMT_FILES=$(gofmt -l .)
  if [ -n "$GOFMT_FILES" ]; then
    log_error "gofmt failed for the following files:
---
$GOFMT_FILES
---
please run 'gofmt -w .' on your changes before committing."
    exit 1
  fi
}

run_golint() {
  GOLINT_ERRORS=$(golint ./... | grep -v "Id should be")
  if [ -n "$GOLINT_ERRORS" ]; then
    log_error "golint failed for the following reasons:
---
$GOLINT_ERRORS
---
please run 'golint ./...' on your changes before committing."
    exit 1
  fi
}

run_govet() {
  GOVET_ERRORS=$(go vet ./... 2>&1)
  if [ -n "$GOVET_ERRORS" ]; then
    log_error "go vet failed for the following reasons:
---
$GOVET_ERRORS
---
please run 'go tool vet ./*.go' on your changes before committing."
    exit 1
  fi
}

main
