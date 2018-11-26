#!/bin/bash

nmcli con show

NAME                  UUID                                  TYPE      DEVICE  
docker0               5bc3bac1-8eb9-4a68-accc-7fa4fc830b3c  bridge    docker0 
telenet-43475         2efc34e4-1cd7-45f7-8e1d-8bb54ea8a410  wifi      wlan0   
TELENETHOMESPOT       16e37d60-a7af-4d9e-a922-18b6d8d3e3d5  wifi      --      
UH Hacking Room L2TP  d850d3aa-7da2-4aec-88aa-8c6c6f7bb912  vpn       --      
Wired connection 1    c751187a-b16a-3867-bdfb-645ec78666ef  ethernet  --      
ZTE_H168N522922       aeea3edf-a9b0-46c4-89a9-c8ade637ae80  wifi      --      
telenet-43475         de2eab07-62e5-48f4-ab9e-0688db35290c  wifi      --     


nmcli conn show --active

NAME           UUID                                  TYPE    DEVICE  
docker0        5bc3bac1-8eb9-4a68-accc-7fa4fc830b3c  bridge  docker0 
telenet-43475  2efc34e4-1cd7-45f7-8e1d-8bb54ea8a410  wifi    wlan0   


nmcli con mod <network_connection_name>

#### Adding a new connection
# nmcli con add type type of the connection "con-name" connection name  ifname ifname interface-name the name of the interface ipv4 address ipv4 address gw4 address gateway address
