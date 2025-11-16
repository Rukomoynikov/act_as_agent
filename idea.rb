# frozen_string_literal: true

class MyCodingAgent
  include ActAsAgent::Base

  tools [edit_file, read_file, list_files, run_rspec]

  def task_with; end
end

class BookAuthorAgent
  include ActAsAgent::Base

  tools [edit_file, read_file, list_files]

  def task_with; end
end

class GameCreatorAgent
  include ActAsAgent::Base

  tools [edit_file, read_file, list_files]

  def task_with; end
end
