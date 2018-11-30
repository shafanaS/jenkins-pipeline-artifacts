#!/usr/bin/env bash
# ------------------------------------------------------------------------
# Copyright 2018 WSO2, Inc. (http://wso2.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License

# This script produces a cicd compatible puppet-module from the provided wso2 puppet-module

while getopts ":p:" opt; do
  case ${opt} in
    p )
      PUPPET_MODULE_LOC=$OPTARG
      ;;
    \? )
      echo "Invalid option: $OPTARG" 1>&2
      exit 1
      ;;
    : )
      echo "Invalid option: $OPTARG requires an argument" 1>&2
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))



# This function will append set of elements defined in the array to the element <parameter name="AvoidInitiation"> in axis2.xml
# Argument is Axis2 file
function add_membership_schema() {
    declare -a arr=(
    "<parameter name="membershipScheme">aws</parameter>"
    "<parameter name="accessKey"><%= @aws_access_key %></parameter>"
    "<parameter name="secretKey"><%= @aws_secret_key %></parameter>"
    "<parameter name="securityGroup">WSO2SecurityGroup</parameter>"
    "<parameter name="region"><%= @aws_region %></parameter>"
    "<parameter name="tagKey">cluster</parameter>"
    "<parameter name="tagValue">ei</parameter>")

    for i in "${arr[@]}"
    do
       # replace spacial character "/"
       REPLACEMENT=$(echo $i | sed 's/\//\\\//g')
       sed -i "/<parameter name=\"AvoidInitiation\"/ a ${REPLACEMENT}" $1
    done
}

AXIS2_FILE="$PUPPET_MODULE_LOC/modules/ei_integrator/templates/carbon-home/conf/axis2/axis2.xml"
add_membership_schema ${AXIS2_FILE}


