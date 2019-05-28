def inst_name
  $LAMBY_INSTALLER_NAME
end

def app_file(path)
  Rails.root.join(path)
end

def tpl_file(path)
  "#{__dir__}/#{inst_name}/#{path}"
end

def shr_file(path)
  "#{__dir__}/shared/#{path}"
end

def appname
  Rails.application.class.parent.name
end
