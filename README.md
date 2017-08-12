# controlrepo

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with the control repo](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with the control repo - Usage](#beginning-with-control-repo)

## Description

A most basic module to show the principle of a control repo. 

## Setup

### Setup Requirements 

Install ```bundle``` from your upstream repository.

Run a user gem install as in ```bundle install --path=$HOME/.gem```. Install
vagrant and virtualbox.

### Beginning with the control repo - Usage

Create the instances to operate on invoking ```bundle exec kitchen create```.
Witness convergance invoking ```bundle exec kitchen converge```.
Do not forget to destroy invoking ```bundle exec kitchen destroy```.
You can list the scenarios invoking ```bundle exec kitchen list```.

Simulating a lot of virtual machines on a single machine will consume *lots*
of memory. In addition, virtualbox can be slow at times.
