$projects = { 
  'project1' => { 'project_id' => 'project1_id' },
  'project2' => { 'project_id' => 'project2_id' }
}

class { 'testbed::gce': projects => $projects, }
