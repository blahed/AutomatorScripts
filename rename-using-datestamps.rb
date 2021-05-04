require 'fileutils'

ARGF.each do |f|
  current_path = f.strip
  next if File.directory?(current_path)

  directory = File.dirname(current_path)
  extension = File.extname(current_path)
  mtime     = File.stat(current_path).mtime
  filename  = "#{mtime.strftime("%Y-%m-%dT%H%M%S")}#{extension.downcase}"
  new_path  = File.join(directory, filename)

  FileUtils.mv(current_path, new_path) unless File.exist?(new_path)
end