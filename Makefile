build:
	dotnet build src/NTextCat.netcore.sln

pack:
	dotnet pack --include-source --include-symbols -c Release -o ../../nupkgs ./src/NTextCat.netcore.sln