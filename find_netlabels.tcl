################################################################################
# Name: setup_users.py                                                         #
# Purpose: configure ESI, PUTTY proflies and putty keys                        #
#                                                                              #
# Release: 03/Aug/2021                                                         #
# Author: Henry Frankland @ EDA Solutions Ltd.                                 #
# Contact: Support@eda-solutions.com                                           #
#                                                                              #
# Please use this script at your own discretion and responsbility. Eventhough  #
# This script was tested and passed the QA criteria to meet the intended       #
# specifications and behaviors upon request, the user remains the primary      #
# responsible for the sanity of the results produced by the script.            #
# The user is always advised to check the imported design and make sure the    #
# correct data is present.                                                     #
#                                                                              #
# For further support or questions, please e-mail support@eda-solutions.com    #
#                                                                              #
# Test platform version: S-Edit 2021.2 Update 0 Release build                  #
################################################################################
# --------------------------
# Installation:- 
# --------------------------
# 1. adjust line 48 to the desired zoom level
# 2. for one time use drag and drop the script into S-edit command window,
# for persistent use copy the script into the 
# '%APPDATA%\Roaming\Tanner EDA\scripts\startup.sedit' folder
# --------------------------
# Usage:-
# --------------------------
# 1. Select a netlabel
# 2. Use the hotkey combination ‘Ctrl+Alt+F’ to Find instances
# 3. if the command window indicate there is more instances keep pressing
# ‘Ctrl+Alt+F’ to scroll through
# 4. to search for a new label select the new label and press the hotkey combo
# --------------------------
# Notes:
# --------------------------
# . the script is a demo script to demonstrate how you can leverage tcl to
# assign hotkeys to find functionality. this script could be enhanced to allow
# a hotkey to scroll back through the list of selected net labes
################################################################################
#########################################################################
#                                                                       #
#   History:                                                            #
#   Version 0.0 |- Created  script                                      #
#           1.0 | 07/09/2022 - Script file first created                #
#           1.1 | 07/09/2022 - Script completed                         #
#########################################################################
    
    
variable nName
variable count
variable nLabelC
set nName ""
setup selection set -zoompercent 30    
proc find_labels {} {
    #get the name of the select variable
    global nName
    global count
    global nLabelC

    #figure out if func been run before, run before but new port selected, or continue incrementing
    if {[llength $nName] == 0} {
        # never run before
        set nName [property get -system -name Name]
        #test is selected item a net label. 0 means no.
        set nLabelC [find netlabel -scope view -name $nName -nocase -contains -count]
        if {$nLabelC == 0} { puts "ERROR: No labels found, please select a valid label"; return 1}
        #clear the count which highlights everything
        find netlabel -scope view -name -nocase -contains -first
        highlight -net $nName
        #restart the scroll counter
        set count 1
    } elseif {[property get -system -name Name] != $nName} {
        # run before but new label selected
        set nName [property get -system -name Name]
        #test is selected item a net label. 0 means no.
        set nLabelC [find netlabel -scope view -name $nName -nocase -contains -count]
        if {$nLabelC == 0} { puts "ERROR: No labels found, please select a valid label"; return 1}
        #clear the count which highlights everything
        find netlabel -scope view -name -nocase -contains -first
        highlight -net $nName
        #restart the scroll counter
        set count 1
    } elseif {$count == $nLabelC} {
        #no more labels!
        set nName ""
        puts "/////////////////////////////////"
        puts "SCRIPT WARNING No more labels!"
        puts "/////////////////////////////////"
    } else {
        #continue with numbering
        set a [expr $count + 1]
        set count $a
    }
    #gaurd cluase to exit the function if the label count is zero. i.e no label selected
    if {$nLabelC == 0} {puts "ERROR: No labels found, please select a valid label"; return 1}
    find netlabel -scope view -name $nName -nocase -contains -next
    #only print statment once when count is 1
    if {$count == 1} {puts "SCRIPT FOUND: $nLabelC of $nName net labels"}
    puts "SCRIPT  NOTE: $count/$nLabelC"
}

workspace menu -name {EDA_Scripts "Find_nodes"} -command find_labels

workspace bindkeys -command {find_labels} -key "Ctrl+Alt+F"

puts "/////////////////////////////////"
puts "SCRIPT LOADED: find_netlabels"
puts "SCRIPT ADDED SHORTCUT: find_labels (Ctrl+Alt+F)"
puts "/////////////////////////////////"