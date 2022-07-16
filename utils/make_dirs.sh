#!bin/bash

function create_project_dirs() {
    # $1 project name

    mkdir $1;
    cd $1;
    mkdir src;
    mkdir test;
    dotnet new sln;
    dotnet new gitignore;

    create_layers $(pwd)/src $1;
}

function create_layers() {
    # $1 => project src path
    # $2 => project name

    cd $1;

    mkdir $2.Application;
    dotnet new classlib -o ./$2.Application;

    mkdir $2.Domain;
    dotnet new classlib -o ./$2.Domain;

    mkdir $2.Contracts;
    dotnet new classlib -o ./$2.Contracts;

    mkdir $2.Infrastructure;
    dotnet new classlib -o ./$2.Infrastructure;

    mkdir $2.Host;
    dotnet new webapi -o ./$2.Host;

    mkdir $2.Core;
    dotnet new classlib -o ./$2.Core;

    dirs_array=($1/$2.Application $1/$2.Domain $1/$2.Contracts $1/$2.Infrastructure $1/$2.Host $1/$2.Core);

    for str in ${dirs_array[@]}; do
        set_ref $str $2
    done

    for str in ${dirs_array[@]}; do
        clean_up_projects $str
    done
}

function clean_up_projects() {
    filename=$(sed 's#.*/##' <<< $1)
    proj_name=${filename##*.}
    
    if [ "$proj_name" == "Host" ]; then
        rm -rf $1/Controllers/
        rm $1/WeatherForecast.cs
    else
        rm $1/Class1.cs
    fi

    if [ "$proj_name" == "Application" ]; then
        mkdir -p $1/Controllers/Index
        mkdir $1/Consumers
    elif [ "$proj_name" == "Core" ]; then
        mkdir $1/Jobs
        mkdir $1/Services
    elif [ "$proj_name" == "Domain" ]; then
        mkdir $1/Aggregates
        mkdir $1/Models
    fi 
}
