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

    echo $1;
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
}
