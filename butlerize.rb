require 'optparse'

module BuildMetaData
  def project_name
    # "a_fight_on_the_waves"
    "idk_my_bff_jill"
  end

  def project_path
    "/home/mark/fuel/data/synced_workspace/projects/LDJAM43/code/godot_project"
  end

  def build_path
    "/home/mark/fuel/data/games/godot/builds/ludum_dare/43_#{project_name}"
  end

  def project_version
    @project_version ||= get_project_version
  end

  def get_project_version
    print "reading project version...."
    File.open(project_path + "/version.txt", 'r') do |f|
      result = f.each_line.first.chomp
      puts result
      puts
      result
    end
  end

  def build_dirs
    {
      windows: "#{project_name}_#{project_version}_windows",
      linux: "#{project_name}_#{project_version}_linux",
      mac: "#{project_name}_#{project_version}_mac",
      mac_hi_res: "#{project_name}_#{project_version}_mac_hi_res",
    }
  end

  def executable_name
    {
      windows: "#{project_name}_#{project_version}_windows.exe",
      linux: "#{project_name}_#{project_version}_linux.x11",
      mac: "#{project_name}_#{project_version}_mac.zip",
      mac_hi_res: "#{project_name}_#{project_version}_mac_hi_res.zip",
    }
  end

  def full_build_dir(channel)
    build_path + "/" + build_dirs[channel]
  end
end

# butler push directory user/game:channel
module Butler
  include BuildMetaData

  def user_game
    # "markopolodev/crux-swarm-butler-test"
    # "markopolodev/crux-swarm"
    # "markopolodev/a-fight-on-the-waves"
    "markopolodev/ldjam-43"
  end

  def channels
    {
      windows: "windows",
      linux: "linux-x11",
      mac: "mac-osx",
      mac_hi_res: "mac-osx-hi-res",
    }
  end

  def version_arg
    "--userversion-file version.txt"
  end

  def push_command(channel)
    build_dir = "meepmerp"
    if [:mac, :mac_hi_res].include?(channel)
      build_dir = full_build_dir(channel) + '/' + executable_name[channel]
    else
      build_dir = full_build_dir(channel)
    end
    "butler push #{build_dir} #{user_game}:#{channels[channel]} #{version_arg}"
  end
end



module Godot
  include BuildMetaData

  def presets
    {
      windows: "windows",
      linux: "linux",
      mac: "mac",
      mac_hi_res: "mac_hi_res",
    }
  end

  def export_command(channel)
    "godot --path #{project_path} --export-debug #{presets[channel]} #{full_build_dir(channel)}/#{executable_name[channel]}"
  end

  def mkdir_command(channel)
    "mkdir #{full_build_dir(channel)}"
  end

  def clean_command(channel)
    "rm -Ir #{full_build_dir(channel)}"
  end
end


def all_channels
  [
    :windows,
    :linux,
    :mac,
    :mac_hi_res
  ]
end

def godot_build(channels, actually_do_it=false)
  godot = Object.new
  godot.extend Godot

  channels.each do |channel|
    puts
    puts godot.clean_command(channel)
    puts godot.mkdir_command(channel)
    puts godot.export_command(channel)
    if actually_do_it
      system godot.clean_command(channel)
      system godot.mkdir_command(channel)
      system godot.export_command(channel)
    end
  end
end

def butler_push(channels, actually_do_it=false)
  butler = Object.new
  butler.extend Butler

  channels.each do |channel|
    puts
    puts butler.push_command(channel)
    if actually_do_it
      system butler.push_command(channel)
    end
  end
end



options = {
  do_it: false
}

OptionParser.new do |opts|
  opts.banner = "Usage: ruby butlerize.rb [options]"

  opts.on("--godot", "build channels with godot") do |v|
    options[:godot] = true
  end

  opts.on("--butler", "push channels with butler") do |v|
    options[:butler] = true
  end

  opts.on("-w", "--windows", "use windows channel") do |v|
    options[:channels] ||= []
    options[:channels] << :windows
  end

  opts.on("-l", "--linux", "use linux channel") do |v|
    options[:channels] ||= []
    options[:channels] << :linux
  end

  opts.on("-m", "--mac", "use mac channels") do |v|
    options[:channels] ||= []
    options[:channels] << :mac
    options[:channels] << :mac_hi_res
  end

  opts.on("--yes-do-it", "actually do the thing") do
    options[:do_it] = true
  end

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end
end.parse!



if options[:godot]
  godot_build options[:channels], options[:do_it]
end

if options[:butler]
  butler_push options[:channels], options[:do_it]
end












