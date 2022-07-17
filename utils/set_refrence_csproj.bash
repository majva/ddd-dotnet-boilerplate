
function set_ref() {

    filename=$(sed 's#.*/##' <<< $1)

    head -n -1 $1/$filename.csproj > $1/temp.txt;
    mv $1/temp.txt $1/$filename.csproj;

    domainfile=(${filename//./ })

    proj_name=${filename##*.}

    if [ "$proj_name" == "Infrastructure" ]; then
        newtext="
    <ItemGroup>
        <ProjectReference Include=\"..\\\\${2}.Domain\\\\${domainfile}.Domain.csproj\" />
    </ItemGroup>
</Project>
        "
        printf "$newtext" >> $1/$filename.csproj
        dotnet add $1/$filename.csproj package Rimple.EfCore
    elif [ "$proj_name" == "Domain" ]; then
        newtext="
</Project>
        "
        printf "$newtext" >> $1/$filename.csproj
        dotnet add $1/$filename.csproj package Rimple.Abstractions
    elif [ "$proj_name" == "Contract" ]; then
        newtext="
</Project>
        "
        printf "$newtext" >> $1/$filename.csproj
    elif [ "$proj_name" == "Core" ]; then
            newtext="
    <ItemGroup>
        <ProjectReference Include=\"..\\\\${2}.Contracts\\\\${2}.Contracts.csproj\" />
        <ProjectReference Include=\"..\\\\${2}.Infrastructure\\\\${2}.Infrastructure.csproj\" />
    </ItemGroup>
</Project>
        "
        printf "$newtext" >> $1/$filename.csproj
    elif [ "$proj_name" == "Application" ]; then
            newtext="
    <ItemGroup>
        <ProjectReference Include=\"..\\\\${2}.Core\\\\${2}.Core.csproj\" />
    </ItemGroup>
</Project>
        "
        printf "$newtext" >> $1/$filename.csproj
    elif [ "$proj_name" == "Host" ]; then
            newtext="
    <ItemGroup>
        <ProjectReference Include=\"..\\\\${2}.Application\\\\${2}.Application.csproj\" />
    </ItemGroup>
</Project>
        "
        printf "$newtext" >> $1/$filename.csproj
    fi
}
