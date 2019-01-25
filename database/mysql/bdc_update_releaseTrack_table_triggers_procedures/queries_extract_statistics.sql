# This query is useful for extracting the list of releases in REF during a specified period of time:

mysql> select project_id as thisProject, Project.name, (select count(*) from releaseTrack where project_id = thisProject and env_type = 8 and date >= '2018-12-10 00:00:00' and date <= '2019-01-13 23:59:59') as numberRefReleases from releaseTrack join Project on releaseTrack.project_id = Project.id group by project_id order by name;

# In case the non-deployed projects are not listed, use this query:

select project_id, Project.name, count(*) from releaseTrack left outer join Project on releaseTrack.project_id = Project.id where env_type = 8 and date >= '2018-12-10 00:00:00' and date <= '2019-01-13 23:59:59' group by project_id;

