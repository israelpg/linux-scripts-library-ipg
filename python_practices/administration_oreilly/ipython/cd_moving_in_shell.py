In [171]: dhist
Directory history (kept in _dh)
0: /home/israel/git_repos/linux-scripts-library-ipg/python_practices/administration_oreilly
1: /home/israel/git_repos/linux-scripts-library-ipg/python_practices/administration_oreilly/monitoring
2: /home/israel/git_repos/linux-scripts-library-ipg/python_practices/administration_oreilly
3: /tmp
4: /home/israel
5: /tmp
6: /home/israel

# You can specify number of lines in history:

dhist 5

# from id to id:

dhist 3 7

### Below another option with less flexibility though:
### using cd -

In [172]: cd -
               -0 [/home/israel/git_repos/linux... -5 [/tmp]                          
               -1 [/home/israel/git_repos/linux... -6 [/home/israel]                  
               -2 [/home/israel/git_repos/linux...                                    
               -3 [/tmp]                                                             
               -4 [/home/israel]                                                     

