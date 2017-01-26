# == Class: pure_postgres::install
#
# Installs postgres from pure repo in a bare format (without running initdb on /var/pgpure/postgres/9.6/data)
class pure_postgres::install
(
  $pg_version           = $pure_postgres::params::version,
  $do_initdb            = $pure_postgres::params::do_initdb,
) inherits pure_postgres
{
   if !$do_initdb {
      #Doing this before installing rpm prevents initdb in rpm,
      #which helps in idempotency state detection of new cluster.

      class { 'pure_postgres::postgres_user':
      } ->

      file { [  '/var/pgpure', '/var/pgpure/postgres', "/var/pgpure/postgres/$pg_version", "/var/pgpure/postgres/$pg_version/data" ]:
         ensure               => 'directory',
         owner                => 'postgres',
         group                => 'postgres',
         mode                 => '0700',
      }

   }

#This is done by the postgres package aswell...
#   package {"postgres-$pg_version":
#       ensure  => 'installed',
#   }

}

