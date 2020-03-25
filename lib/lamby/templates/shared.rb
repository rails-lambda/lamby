def inst_name
  $LAMBY_INSTALLER_NAME
end

def app_file(path)
  Rails.root.join(path)
end

def tpl_file(path)
  "#{__dir__}/#{inst_name}/#{path}"
end

def appname
  k = Rails.application.class
  p = k.respond_to?(:module_parent) ? k.module_parent : k.parent
  p.name
end
