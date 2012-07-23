#!bin/sh

#################################################
#    deploy scritp to automate installation     #
#################################################

#### Test  ####

if [ -d $HOME/.vim ] ; then
    echo "Directory $HOME/.vim exist aborting"
    exit 1
fi

if [ -f $HOME/.vimrc ] ; then
    echo "File $HOME/.vimrc exist aborting"
    exit 2
fi


cwd=`pwd`

if [ ! -d $cwd/.vim ] ; then
    echo "Directory $cwd/.vim is not exist aborting"
    exit 4
fi

if [ ! -f $cwd/.vimrc ] ; then
    echo "File $cwd/.vimrc is not exist aborting"
    exit 5
fi


#### Deploy ####

ln -s $HOME/.vimrc $cwd/.vimrc
ln -s $HOME/.vim $cwd/.vim
