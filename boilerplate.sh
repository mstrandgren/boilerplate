#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

run() {
	check_environment || exit 1

	project_name=$1
	working_dir=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
	project_dir="$working_dir/$project_name"

	printf "Setting up project ${CYAN}${project_name}${NC}\n"
	exit 0

	mkdir $project_dir || printf "${RED}ERROR: $project_dir already exists${NC}\n"; exit 1

	get_boilerplate || rollback
	install_dependencies || rollback
	create_local_repo
	create_remote_repo
	create_sublime_project

	printf "\n${GREEN} -------- ALL DONE! -------- ${NC}\n"
	printf "${CYAN}To run backend, do:${NC}\n    $ coffee backend/app.coffee\n"
	printf "${CYAN}To run frontend, do:${NC}\n    $ cd frontend && grunt serve\n"

	cd $project_dir
}

rollback() {
	printf "\n${RED}Rolling back...\n${NC}"
	printf "${RED}Deleting $project_name...${NC}\n"
	exit 1
}

check_environment() {
	local status=0
	if [ -z "$(which grunt)" ]; then
		printf "${RED}ERROR: Please install global grunt:${NC}\n"
		printf "    $ sudo npm install -g grunt-cli\n"
		status=1
	fi

	if [ -z "$(which coffee)" ]; then
		printf "${RED}ERROR: Please install global coffeescript:${NC}\n"
		echo "    $ sudo npm install -g coffee-script"
		status=1
	fi

	if [ -z "$BOILERPLATE_BBUSER" -o -z "$BOILERPLATE_BBKEY" ]; then
		while [ -z "$BOILERPLATE_BBUSER" ]; do
			printf "Bitbucket username: "
			read BOILERPLATE_BBUSER
		done

		while [ -z "$BOILERPLATE_BBKEY" ]; do
			printf "Bitbucket api key: "
			read BOILERPLATE_BBKEY
		done
		profile_file="$HOME/.bash_profile"
		echo "" >> $profile_file
		echo "# Bitbucket credentials for boilerplate script" >> $profile_file
		echo "export BOILERPLATE_BBUSER=$BOILERPLATE_BBUSER" >> $profile_file
		echo "export BOILERPLATE_BBKEY=$BOILERPLATE_BBKEY" >> $profile_file
		source $profile_file
		status=0
	fi

	return $status
}

get_boilerplate() {
	cd $project_dir
	git clone --depth 1 git@github.com:mstrandgren/boilerplate.git || return 1
	cp boilerplate/.gitignore .

	if [ $2 = "frontend" ]; then
		cp -Rf boilerplate/frontend/* .
		frontend_dir="$project_dir"
	elif [ $2 = "backend" ]; then
		cp -Rf boilerplate/backend/* .
		backend_dir="$project_dir"

	else
		cp -Rf boilerplate/backend .
		cp -Rf boilerplate/frontend .

		frontend_dir="$project_dir/frontend"
		backend_dir="$project_dir/backend"
	fi

	rm -Rf boilerplate
	return 0
}

install_dependencies() {
	if [ -n "$frontend_dir" ]; then
		cd $frontend_dir
		npm install || return 1
		grunt bower || return 1
		grunt build || return 1
	fi

	if [ -n "$backend_dir" ]; then
		cd $backend_dir
		npm install || return 1
	fi

	return 0
}

create_local_repo() {
	cd $project_dir
	git init
	git add -A
	git commit -am "First commit"
}

create_remote_repo() {
	curl_result=`curl -u $BOILERPLATE_BBUSER:$BOILERPLATE_BBKEY https://bitbucket.org/api/1.0/repositories/ --data "name=$project_name;is_private=true"`

	if [ $(echo "$curl_result" | grep -ic resource_uri) -ne 0 ]; then
		repo_url=git@bitbucket.org:$BOILERPLATE_BBUSER/$project_name.git
		printf "\n${GREEN}OK: ${NC}Created remote repo at ${CYAN}${repo_url}${NC}\n\n"

		cd $project_dir
		git remote add origin $repo_url
		git push -u origin --all
		return 0
	else
		printf "${RED}ERROR: Failed to create remote repo: ${NC}\n${curl_result}\n"
		return 1
	fi
}

create_sublime_project() {
	sublime_project="$working_dir/$project_name.sublime-project"
	result=$(echo '{"folders":[{"path": "$project_name","folder_exclude_patterns": ["build", "node_modules", "bower_components"]}]}' > "$sublime-project")
	if [ $result = 0 ]; then
		printf "${GREEN}OK: ${NC}Created sublime project at ${CYAN}$sublime_project${NC}\n"
	else
		printf "${RED}ERROR: Could not create sublime project"
	fi
	return 0
}

show_help() {
	echo "Showing help"
}

frontend=0
backend=0

while	getopts "hfbrs" opt; do
	case "$opt" in
		h) show_help; exit 0;;
		f) frontend=1;;
		b) backend=1;;
		r) remote_repo=1;;
		s) sublime_project=1;;
	esac
done

if [[ $frontend -eq 0 && $backend -eq 0 ]]; then
	frontend=1
	backend=1
fi



echo "frontend: $frontend"
echo "backend: $backend"
echo "remote_repo: $remote_repo"
echo "sublime_project: $sublime_project"

