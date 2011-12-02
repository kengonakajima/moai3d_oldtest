



lastmtime={}
while true
  sleep 0.2
  changed=false
  Dir.glob("*.lua").each do |fn|
    next if fn =~ /^_/
    s = File::Stat.new(fn)
    if s.mtime != lastmtime[fn] then
      changed=true
      print fn, ": ", s.mtime, "  ",s.size, "\n"
      lastmtime[fn] = s.mtime
    end
  end
  if changed then
    system( ARGV[1] )
    system( ARGV[0] )
  end
end
