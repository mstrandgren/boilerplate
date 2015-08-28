# Boilerplate Project Setter-Upper

Utility to set up a boilerplate project based on a git repo. This particular
repo is partial to grunt, coffeescript, browserify, react, and sublime text,
since that's what I use. It could easily be switched to something else.

## Usage

1. Clone the repo:

```
$ git clone -d 1 git@github.com:mstrandgren/boilerplate.git
```

2. Set execution rights and copy the script someplace nice

```
$ chmod 755 boilerplate/boilerplate && cp boilerplate/boilerplate /usr/local/bin
```

3. Remove the local clone again (optional)
```
$ rm -rf boilerplate
```

4. Now set up a new project like so:
```
$ boilerplate my-new-project
```

### More options

```
Usage: boilerplate [opts] [branch] project_name

-c		Client app only
-s		Server app only
-r		Create remote repo (will prompt for bitbucket credentials the first time)
-p		Create sublime project
-b <branch>	Use a specific branch, other than master
-l		Give the project an MIT license (you need to change the name in the license manually)
-h		Show this help message
```

## To Customize

1. Fork the repo
2. Change the ```BOILERPLATE_REPO``` in /boilerplate (on the top) to your fork
3. Go wild

## Pull Requests Welcome

1. Feature branches with different types of projects are conveniently accessible
through the ```-b``` flag. So PR away for different types of boilerplates.

2. Auto-generating projects for more editors than sublime would be nice. I hear there
are confused souls that don't use sublime.

3. Can't come up with any more stuff now. Sure someone else can.