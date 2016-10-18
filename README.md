# Juntos.com.vc

[![Build Status](https://travis-ci.org/juntos-com-vc/juntos.com.vc.svg?branch=master)](https://travis-ci.org/juntos-com-vc/juntos.com.vc)
[![Code Climate](https://codeclimate.com/github/juntos-com-vc/juntos.com.vc/badges/gpa.svg)](https://codeclimate.com/github/juntos-com-vc/juntos.com.vc)
[![Coverage Status](https://coveralls.io/repos/github/juntos-com-vc/juntos.com.vc/badge.svg?branch=master)](https://coveralls.io/github/juntos-com-vc/juntos.com.vc?branch=master)

## An open source crowdfunding platform for creative projects

Welcome to Juntos's source code repository.
Our goal with opening the source code is to stimulate the creation of a community of developers around a high-quality crowdfunding platform.

You can see the software in action in http://juntos.com.vc.
The official repo is https://github.com/juntos-com-vc/juntos.com.vc

## Getting started

### Dependencies

To run this project you need to have:

* Ruby 2.1.8
* [PostgreSQL](http://www.postgresql.org/)
  * OSX - [Postgress.app](http://postgresapp.com/)
  * Linux - `$ sudo apt-get install postgresql`
  * Windows - [PostgreSQL for Windows](http://www.postgresql.org/download/windows/)

  **IMPORTANT**: Make sure you have postgresql-contrib ([Aditional Modules](http://www.postgresql.org/docs/9.3/static/contrib.html)) installed on your system.
* XML Library
  * Linux = `$ sudo apt-get install libxml2-dev`

### Setup the project

* Clone the project

        $ git clone https://github.com/juntos-com-vc/juntos.com.vc.git

* Enter project folder

        $ cd juntos.com.vc

* Create the `database.yml`

        $ cp config/database.sample.yml config/database.yml

    Add your database credentials

* Create a copy of `.env.example` called `.env` and add your credentials to it

        $ cp .env.example .env

* Install the gems

        $ bundle install

* Create the database

        $ rake db:create db:migrate

If everything goes OK, you can now run the project!

### Running the project

Start the local server

```bash
$ rails server
```

Open [http://localhost:3000](http://localhost:3000)
