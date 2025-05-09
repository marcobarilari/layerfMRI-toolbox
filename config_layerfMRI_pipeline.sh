# # !bin/bash

# if [[ -v layerfmriconfigured ]]; then

#     echo ""
#     echo "layerfMRI-toolbox is already configured"
#     echo ""

#     return
# fi

# ## set up the environment here below

# # fresurfer
# export FREESURFER_HOME=/usr/local/freesurfer/7.3.2 #monster
# # export FREESURFER_HOME=/Applications/freesurfer/7.4.1 #mac

# source $FREESURFER_HOME/SetUpFreeSurfer.sh

# # matlab
# matlabpath=/usr/local/MATLAB/R2018a/bin/matlab

# ## DO NOT TOUCH HERE BELOW ###################################################

# # get the path of the current script aka the toolbox
# # layerfMRI_toolbox_dir="$(dirname $0)"

# # make all the scripts executable
# find $layerfMRI_toolbox_dir/src -name '*.sh' -exec chmod u+x {} \;

# # add the toolbox to the path
# export PATH=$PATH:$layerfMRI_toolbox_dir
# export PATH=$PATH:$(find $layerfMRI_toolbox_dir/src -maxdepth 1 -type d | paste -sd ":" -)

# ## print messages

echo ""
echo ""
echo "    _____________________________________________________________"
echo "                                      _    _   _    ____       __"
echo "        /                           /      /  /|    /    )     / "
echo "    ---/----__----------__---)__--_/__----/| /-|---/___ /-----/--"
echo "      /   /   ) /   / /___) /   ) /      / |/  |  /    |     /     - toolbox is ready to use"
echo "    _/___(___(_(___/_(___ _/_____/______/__/___|_/_____|__ _/_ __"
echo "                  /                                              "
echo "    __________(_ /_______________________________________________"
echo ""
echo ""
echo "    Contributors: "
echo "      - Marco Barilari"
echo "      - Kenshu Koiso"
echo "      - Paul A. Taylor"
echo "      - Omer Faruk Gulban Taylor"
echo "      - Daniel Glen"
echo "      - Peter Bandettini"
echo "      - Olivier Collignon"
echo "      - Renzo Huber"
echo "      - et al. ... do you want to be the next one?"
echo ""
echo ""


layerfmriconfigured=1

















# ======================================================================
# =  ==================================    ===  =====  ==       ===    =
# =  =================================  ==  ==   ===   ==  ====  ===  ==
# =  =================================  ======  =   =  ==  ====  ===  ==
# =  ===   ===  =  ===   ===  =   ===    =====  == ==  ==  ===   ===  ==
# =  ==  =  ==  =  ==  =  ==    =  ===  ======  =====  ==      =====  ==
# =  =====  ===    ==     ==  ========  ======  =====  ==  ====  ===  ==
# =  ===    =====  ==  =====  ========  ======  =====  ==  ====  ===  ==
# =  ==  =  ==  =  ==  =  ==  ========  ======  =====  ==  ====  ===  ==
# =  ===    ===   ====   ===  ========  ======  =====  ==  ====  ==    =
# ======================================================================


#      _/\/\______________________________________________________/\/\/\__/\/\______/\/\__/\/\/\/\/\____/\/\/\/\_
#     _/\/\____/\/\/\______/\/\__/\/\____/\/\/\____/\/\__/\/\__/\/\______/\/\/\__/\/\/\__/\/\____/\/\____/\/\___ 
#    _/\/\________/\/\____/\/\__/\/\__/\/\/\/\/\__/\/\/\/\____/\/\/\____/\/\/\/\/\/\/\__/\/\/\/\/\______/\/\___  
#   _/\/\____/\/\/\/\______/\/\/\/\__/\/\________/\/\________/\/\______/\/\__/\__/\/\__/\/\__/\/\______/\/\___   
#  _/\/\/\__/\/\/\/\/\________/\/\____/\/\/\/\__/\/\________/\/\______/\/\______/\/\__/\/\____/\/\__/\/\/\/\_    
# _____________________/\/\/\/\_____________________________________________________________________________     


# _/\/\______________________________________________________/\/\/\__/\/\______/\/\__/\/\/\/\/\____/\/\/\/\_
# _/\/\____/\/\/\______/\/\__/\/\____/\/\/\____/\/\__/\/\__/\/\______/\/\/\__/\/\/\__/\/\____/\/\____/\/\___
# _/\/\________/\/\____/\/\__/\/\__/\/\/\/\/\__/\/\/\/\____/\/\/\____/\/\/\/\/\/\/\__/\/\/\/\/\______/\/\___
# _/\/\____/\/\/\/\______/\/\/\/\__/\/\________/\/\________/\/\______/\/\__/\__/\/\__/\/\__/\/\______/\/\___
# _/\/\/\__/\/\/\/\/\________/\/\____/\/\/\/\__/\/\________/\/\______/\/\______/\/\__/\/\____/\/\__/\/\/\/\_
# _____________________/\/\/\/\_____________________________________________________________________________



# ooo_____________________________________oooo_ooo_____ooo_ooooooo___oooo_
# _oo____ooooo___o___oo__ooooo__oo_ooo___oo____oooo___oooo_oo____oo___oo__
# _oo___oo___oo__o___oo_oo____o_ooo___o_ooooo__oo_oo_oo_oo_oo____oo___oo__
# _oo___oo___oo__o___oo_ooooooo_oo______oo_____oo__ooo__oo_ooooooo____oo__
# _oo___oo___oo___ooooo_oo______oo______oo_____oo_______oo_oo____oo___oo__
# ooooo__oooo_o_o____oo__ooooo__oo______oo_____oo_______oo_oo_____oo_oooo_
# _______________ooooo____________________________________________________

# .........................................................................
# .%%.......%%%%...%%..%%..%%%%%%..%%%%%...%%%%%%..%%...%%..%%%%%...%%%%%%.
# .%%......%%..%%...%%%%...%%......%%..%%..%%......%%%.%%%..%%..%%....%%...
# .%%......%%%%%%....%%....%%%%....%%%%%...%%%%....%%.%.%%..%%%%%.....%%...
# .%%......%%..%%....%%....%%......%%..%%..%%......%%...%%..%%..%%....%%...
# .%%%%%%..%%..%%....%%....%%%%%%..%%..%%..%%......%%...%%..%%..%%..%%%%%%.
# .........................................................................


# .........................................................................
# .##.......####...##..##..######..#####...######..##...##..#####...######.
# .##......##..##...####...##......##..##..##......###.###..##..##....##...
# .##......######....##....####....#####...####....##.#.##..#####.....##...
# .##......##..##....##....##......##..##..##......##...##..##..##....##...
# .######..##..##....##....######..##..##..##......##...##..##..##..######.
# .........................................................................


# __/\\\\\\_____________________________________________________________________/\\\\\__/\\\\____________/\\\\____/\\\\\\\\\______/\\\\\\\\\\\_        
#  _\////\\\___________________________________________________________________/\\\///__\/\\\\\\________/\\\\\\__/\\\///////\\\___\/////\\\///__       
#   ____\/\\\______________________/\\\__/\\\__________________________________/\\\______\/\\\//\\\____/\\\//\\\_\/\\\_____\/\\\_______\/\\\_____      
#    ____\/\\\_____/\\\\\\\\\______\//\\\/\\\______/\\\\\\\\___/\\/\\\\\\\___/\\\\\\\\\___\/\\\\///\\\/\\\/_\/\\\_\/\\\\\\\\\\\/________\/\\\_____     
#     ____\/\\\____\////////\\\______\//\\\\\_____/\\\/////\\\_\/\\\/////\\\_\////\\\//____\/\\\__\///\\\/___\/\\\_\/\\\//////\\\________\/\\\_____    
#      ____\/\\\______/\\\\\\\\\\______\//\\\_____/\\\\\\\\\\\__\/\\\___\///_____\/\\\______\/\\\____\///_____\/\\\_\/\\\____\//\\\_______\/\\\_____   
#       ____\/\\\_____/\\\/////\\\___/\\_/\\\_____\//\\///////___\/\\\____________\/\\\______\/\\\_____________\/\\\_\/\\\_____\//\\\______\/\\\_____  
#        __/\\\\\\\\\_\//\\\\\\\\/\\_\//\\\\/_______\//\\\\\\\\\\_\/\\\____________\/\\\______\/\\\_____________\/\\\_\/\\\______\//\\\__/\\\\\\\\\\\_ 
#         _\/////////___\////////\//___\////__________\//////////__\///_____________\///_______\///______________\///__\///________\///__\///////////__




