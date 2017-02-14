#!/bin/bash
# @(#) This is xxxxxxxxxxxx.

# Checks unnecessary paramters
set -ue

####################
# GLOBAL CONSTANTS #
####################
readonly DATE=`date +%Y%m%d`
readonly RESULTS_RAW=results.log
readonly RESULTS_CSV=results.csv

####################
# GLOBAL VARIABLES #
####################
EXTENSION=rpm,zip,tar,gz,bz2,tgz
EXCLUDE_EXTENSION=html,txt
#URL=http://oss.sony.net/Products/Linux/
URL=http://panasonic.net/avc/oss/

## Usage
function usage() {
  cat <<EOF
Usage:
  $0 [option]

Description:
  This is script for web crawler.

Environment:
  RESULTS FILE = ${RESULTS}

Options:
  -h,--help       : Print usage
  --extension     : Target file extension (default: $EXTENSION)

Examples:
   Get jpg files;
    \$ $0 --extension jpg
   Show help message;
    \$ $0 --help

EOF
  return 1
}

################
# MAIN ROUTINE #
################

while (( $# > 0 ))
do
  case "$1" in
    '-h'|'--help' )
      usage
      exit 1
      ;;
    '--extension' )
      echo "[CONF] set extenstion as $2"
      EXTENSION=$2
      shift 1
      ;;
    *)
      break
      ;;
  esac
  shift
done

opt="-H --recursive --level inf -w 1 --restrict-file-names=windows --convert-links --no-parent --adjust-extension --spider -nd -nv -o ${RESULTS_RAW}"

if [ ! ${EXTENSION} = "" ]; then
    opt+=" -A ${EXTENSION}"
fi

if [ ! ${EXCLUDE_EXTENSION} = "" ]; then
    opt+=" -R ${EXCLUDE_EXTENSION}"
fi

#wget $opt $URL

echo "URL,OSS" > ${RESULTS_CSV}
egrep "\.rpm|\.zip|\.tar|\.gz|\.bz2|\.tgz" ${RESULTS_RAW} | sed -e "s/^.*http\(.*\)\/\(.*\) .* .*/http\1,\2/g" | sort | uniq > ${RESULTS_CSV}

exit 0
