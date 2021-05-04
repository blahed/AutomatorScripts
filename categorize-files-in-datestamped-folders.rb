require 'fileutils'

osascript = <<~DIALOG
set theDialogText to "Datestamp filenames as well?"
display dialog theDialogText buttons {"Yes", "No"} default button "Yes" cancel button "No"
DIALOG

rename_files = system("osascript -e '#{osascript}'")

ARGF.each do |f|
  current_path = f.strip
  next if File.directory?(current_path)

  directory  = File.dirname(current_path)
  extension  = File.extname(current_path)
  mtime      = File.stat(current_path).mtime
  folders    = File.join(mtime.year.to_s, mtime.strftime("%Y-%m-%d"))
  new_folder = File.join(directory, folders)

  if rename_files
    filename = "#{mtime.strftime("%Y-%m-%dT%H%M%S")}#{extension.downcase}"
  else
    filename = File.basename(current_path, extension) + extension.downcase
  end

  new_path = File.join(new_folder, filename)

  FileUtils.mkdir_p(new_folder)
  FileUtils.mv(current_path, new_path) unless File.exist?(new_path)
end