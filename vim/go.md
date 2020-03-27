## vim-go cheatsheet

```
:GoRun :GoBuild :GoInstall   

:GoDef          # goto definition of object under cursor   
gd              # also has the same effect
Ctrl-O / Ctrl-I # hop back to your source file/return to definition

:GoDoc          # opens up a side window for quick documentationn   
K               # also has the same effect

   
:GoTest         # run every *_test.go file and report results   
:GoTestFunc     # or just test the function under your cursor   
:GoCoverage     # check your test coverage   
:GoAlternate	# switch bewteen your test case and implementation   

:GoImport       # manage and name your imports   
:GoImportAs   
:GoDrop   
   
:GoRename       # precise renaming of identifiers   
   
:GoLint         # lint your code   
:GoVer   
:GoErrCheck   
   
:GoAddTags      # manage your tags   
:GoRemoveTags
```

## vim-fugitive

```
:Gstatus        # run `git status`
:Gdiff          # diff the working tree vs staged version
:Gcommit %      # commit the current file
```

## optional vim plugins

I don't have time for these fancy stuff and they are useless for me.

https://github.com/ryanoasis/nerd-fonts
https://github.com/ryanoasis/vim-devicons
https://github.com/tiagofumo/vim-nerdtree-syntax-highlight