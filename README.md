# Fairscore

Too long has media been unfairly rated due to the fickle whims of the average consumer. This web app stores user media ratings based on the difference from the users mean rating.

Thanks to [TMDb](https://www.themoviedb.org/) for the excellent API and media data.

Designed to be deployed to AWS services:

* Elastic beanstalk
* ElastiCache
* SQS
* RDS

Some manual configuration is required. Status model needs to be seeded manually with SSH into the EBS instance.
