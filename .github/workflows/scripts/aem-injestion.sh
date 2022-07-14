#!/bin/bash
if [ -z "$1" ]; then
  echo "Enter environment name ('dev', 'qa', or 'prod') as first argument."
  exit 1
else
  if [ "$1" == "dev" ]; then
    AEM_ENV_NAME="Develop"
  elif [ "$1" == "qa" ]; then
    AEM_ENV_NAME="Staging"
  elif [ "$1" == "prod" ]; then
    AEM_ENV_NAME="Production"
  else
    echo "First argument needs to be a valid environment name ('dev', 'qa', or 'prod')."
    exit 1
  fi
fi

if [ -z "$2" ]; then
  echo "Enter a comma-separated list of files as the second argument."
  exit 1
fi

# The second argument passed to this script is the md_files output, a comma-separated list of 
# changed markdown files from the pull request, generated in the get-md-files job
MD_FILENAMES=$2

{
  echo "# $AEM_ENV_NAME Injestion Complete"
  echo "## Markdown Files"
  echo "Files were sent to AEM $AEM_ENV_NAME: $MD_FILENAMES"
} >> "$GITHUB_STEP_SUMMARY"

if [ ! -z "$MD_FILENAMES" ]; then
  echo "## Preview URLs" >> "$GITHUB_STEP_SUMMARY"
  # TODO: Update to POST $MD_FILENAMES to AEM endpoint here. AEM injests Github files then returns 
  # the publish staging URLs which will be printed to the job summary here.
  {
    echo "(Dummy example)"
    # Fetch JSON and print 'url' property to job summary
    curl -X GET -s -S "https://raw.githubusercontent.com/rbitting/testing/master/test.json" | jq --raw-output '.url'
  } >> "$GITHUB_STEP_SUMMARY"
else
  # The workflow should only run on PRs that contain .md changes (set in the pull_request_target 
  # of the workflow). Thus this should never happen.
  {
    echo "No .md files were updated in this PR."
    echo "Tell an MSEng developer there is probably an issue here. This script shouldn't run if there aren't any .md files in the PR."
  } >> "$GITHUB_STEP_SUMMARY"
fi
