vimfiles
========

This is location for latest vim configuration.
This time it should be done right. 
I am using pathongen (see https://github.com/tpope/vim-pathogen) as git a submodule.
It is stored as rest of plugins in .vim/bundle/ directory.
Some of them are git submodules so I can update easly.

List of plugins that I use:
    - "pathogen"  Tim pope great plugin that made me reorganize vim once again
    - "A" I use it for C/C++ source for switching b/t source and header file 
    - "Align"  I really like good aligned code, yet the plug-in is somewhat complicated when you want align done right,
        or I just didn't quite mastered it 
    - "ack.vim" just google ack - perl grep replacement, I also have grep but ack is good
    - "clang_complete" this is for experiment for completion against omnicommpleate plug-in but not fully embraced
    - "command-t" great plug-in, find files fast, but pattern matching is something I have to work on, and deployment requires compilation
    - "cscope" small plug-in for cscope commands that I notoriously use for C/C++
    - "makregreen" new addition for runnig unit test makes vim bar as green when tests passes
    - "matchit" plugin for extending usage of * and % to work on {[( etc. 
    - "minibufferexpl" very old plug-in vim had no tab support at that time in terminal so I used that, and I like it
    - "nosenotes" plugin for python nose compiler for unit-test combined with makegreen 
    - "omnicppcompleate" compleation for C++/C from tags files, useful but to a point
    - "quick-buffer" yet again buffer hack, mapped Fn key to use arrows, I don't use it much
    - "rainbow_parentheses" do what it name suggest - time savior for lisp and Makefiles
    - "sessionman" to have some session management, not used, just use screen/tmux and not disable pc/server
    - "supertab" have various completion under tab
    - "taglist" again cool to have but I don't use it often, 
    - "vim-surround" great, not used often but if you need word to be surrounded by "" or '' or whatever, you know where to look for help
    - "xptempleate" cool plug-in for templates, somewhat big but good splited, I have couple of my own templates under personal dir

TODO
    - create deploy script that works from current directory and installs all .vimrc .gvimrc and .vim files/dir
    - correct superTab behaviour, or dupe it. Problems is with omnicompleation and syntax completion in C/C++ 
        sources if no omnicompleation is found it should go to dictionary mode, I am to stupid to do this.
    - correct that Readme.md
