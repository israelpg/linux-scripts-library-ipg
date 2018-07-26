# Utilisites for RM & Process & Tools

## Jenkins
- **listRepos.sh**: look in Jenkins jobs and output all repositories udsed.  The script outputs 2 files: '~/cvsrepos.txt' and '~/svnrepos.txt'


## Jira
- **create-jira-users.sh**: add all users found in file 'jira-users.txt' in Jira, creates a given group and add all users in this group.
- **deamonize.sh**: make Jira a service in Linux with service file 'jira.service' 




## CVS / SVN / BitBucket
### Migration to BitBucket
- **checkout-cvs.sh**: checkout all CVS repositories that are referenced by a Jenkins dev build
- **checkout-svn.sh**: checkout all SVN repositories that are referenced by a Jenkins dev build
- **checkout-git.sh**: checkout all BitBucket repositories referenced in an input file

- **convertcvs2git.sh**: convert a CVS repository into GIT, create the repoand push the code in BitBucket
- **convertsvn2git.sh**: convert a SVN repository into GIT, create the repoand push the code in BitBucket

### Synchro with Arcad
- **checkout-cvs-history.sh**: checkout all files modified since a period for a repo
