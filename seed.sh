#!/bin/bash

rake db:drop
rake db:setup

ruby seed_aws.rb