desc "Check code against Rails Best Practices"
task :rbp do
  path = File.expand_path("../../../", __FILE__)
  sh "rails_best_practices #{path}"
end

desc "Run Brakeman security analysis"
task :brakeman do
  sh "brakeman -q -z"
end

desc "Assess code climate"
task :check do
  Rake::Task['spec'].invoke
  Rake::Task['brakeman'].invoke
  Rake::Task['rails_best_practices'].invoke
end

desc "Deploy to Heroku if build passes code climate check"
task :deploy do
  Rake::Task['check'].invoke
  sh "git push origin heroku"
end
