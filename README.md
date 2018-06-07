# Name my Release

[![Build Status](https://travis-ci.org/itsmethemojo/name-my-release.svg?branch=master)](https://travis-ci.org/itsmethemojo/name-my-release)
[![Heroku](https://heroku-badge.herokuapp.com/?app=name-my-release&style=flat&root=api/namepools)](https://name-my-release.herokuapp.com/api/namepools)

## what is this

An api to retreive unique names for the releases of your application.

## but why

When you work with continuous delivery you may release your software in smaller packages more often.
Semantic versioning is key for modern applications. When i was working with sentry (a frontend
logging tool which is able to map the errors it catches to the software version of your application) me
and my colleges hardly found out that version numbers aren't really catchy to remember which feature or
bugfix was shipped with it. So give every release additionally a name. You know like android does. But this
should be no manual task. There should be an api for that, so that i can easily integrate that in to my
build chain. And it should be reproduceable. If i run a build twice, i should get the same name. Oh and
there should be cool names in it.

And there it is. A reason to write an api.

## software prerequisites

* [docker](https://docs.docker.com/install/#supported-platforms)
* [make](https://formulae.brew.sh/formula/make)

## howto get it running locally
After cloning the repository all you need is **only one command**.
```
make run
```
When the server is running you can [open the application in the browser](http://localhost:3000/api/namepools)

## howto contribute
fork the master and create an pull request

you can run the tests locally with
```
make test
```
