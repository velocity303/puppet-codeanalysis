define codeanalysis (
  $projectkey,
  $projectname,
  $source_code_path   = $title,
  $project_version    = '1.0',
  $sonar_config_store = '/etc/sonarrunner',
) {
  file { "${sonar_config_store}/${projectkey}":
    ensure => directory,
  }
  file { "${sonar_config_store}/${projectkey}/sonar-project.properties":
    ensure  => present,
    mode    => '0755',
    content => "sonar.projectKey=${projectkey}
    sonar.projectName=${projectname}
    sonar.sources=${source_code_path}
    sonar.projectVersion=${project_version}
    sonar.projectBaseDir=${source_code_path}",
  }
  cron { "update sonar code for ${projectname}":
    command => "cd ${sonar_config_store}/${projectkey}; /usr/local/sonar-runner/bin/sonar-runner",
    user    => 'root',
    minute  => '*/30',
  }
}
