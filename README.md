CoreSample Repos - Ubuntu
=========================
This is a git annex enabled repository for Ubuntu packages and assets.
Storing all repository contents here allows us to accomplish point-in-time
builds even with external dependencies for constantly changing repos under
third party control.

Dependencies
------------
* git annex
* apt-mirror (if you'd like to update the repos)

Layout
------
```
repos.yml
{distribution codename}\
  {repository name}\
    {repository class}\
      {component name}.apt-mirror.list # apt-mirror configuration file
      {component name}\ # standard apt mirror directory structure
```

Configuring Remotes for Git Annex
---------------------------------

Public Mirrors
--------------
* S3
    * Primary Mirror - Set to Requester pays. Bucket name: 'core-sample-repo-ubuntu'

Selecting and Installing from Repositories
------------------------------------------

Updating Repos
--------------
TODO
