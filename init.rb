Redmine::Plugin.register :overdue do
  name 'Overdue plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  permission :overdue, { :overdue => [:index] }, :public => true
  menu :project_menu, :overdue, { :controller => 'overdue', :action => 'index' }, :caption => 'Overdue', :param => :project_id
end
