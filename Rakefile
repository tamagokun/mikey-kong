desc "Build project"
task :build => [:config] do
  debug = @config["debug"]? "-debug " : "" 
  system("mxmlc #{debug}-output '#{@config["deploy_to"]}/#{@config["application"]}.swf' #{@config["document_class"]} #{libs} #{swcs}")
end

namespace :console do
  desc "Clear Flash Log"
  task :clear do
    system("cat /dev/null > ~/Library/Preferences/Macromedia/Flash\\ Player/Logs/flashlog.txt")
  end
end

desc "Open Flash Log with Console.app"
task :console do
  system("open -a /Applications/Utilities/Console.app/ ~/Library/Preferences/Macromedia/Flash\\ Player/Logs/flashlog.txt")
end

task :config do
  require 'yaml'
  @config = YAML::load( File.open("config.yml") )
end

def libs
  return @config["libs"].collect! { |i| "-sp '"+i+"'"}.join(" ")
end

def swcs
  if @config["swcs"].nil?
    swc = []
    @config["libs"].each do |path|
      files = Dir.glob(File.join(Rake::original_dir,path,"*.swc"))
      swc += files
    end
    output = "-library-path+=" + swc.join(" ") unless swc.empty?
  else
    output = "-library-path+=" + @config["swcs"].join(" ")
  end
  return output
end